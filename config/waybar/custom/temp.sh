#!/usr/bin/env bash
# Hottest-temperature indicator. Discovers all temperature sensors via lm_sensors
# (and nvidia-smi when present), classifies them with a portable pattern table,
# and emits waybar JSON. Falls back to no-op output when sensors are unavailable.

set -e

source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

command -v sensors >/dev/null 2>&1 || noop
command -v jq      >/dev/null 2>&1 || noop

raw=$(timeout -k 1 2 sensors -j 2>/dev/null) || noop
[[ -z "$raw" ]] && noop

if command -v nvidia-smi >/dev/null 2>&1; then
    nv=$(timeout -k 1 2 nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits 2>/dev/null \
         | head -1 | tr -dc '0-9')
    if [[ -n "$nv" ]]; then
        raw=$(jq --argjson t "$nv" \
              '. + {"nvidia-smi": {"GPU": {"temp1_input": $t}}}' <<< "$raw")
    fi
fi

out=$(jq -c '
    def classify_chip($name):
        ($name | ascii_downcase) as $n |
        if   ($n | test("k10temp|coretemp|zenpower|cpu_thermal"))                   then {cat: "CPU",  mode: "collapse"}
        elif ($n | test("amdgpu|nvidia|radeon|i915"))                                then {cat: "GPU",  mode: "collapse"}
        elif ($n | test("^nvme"))                                                    then {cat: "NVMe", mode: "collapse"}
        elif ($n | test("spd5118|jc42"))                                             then {cat: "RAM",  mode: "collapse"}
        elif ($n | test("asusec|nct[0-9]+|it[0-9]+|f71[0-9]+|w83[0-9]+|smsc[0-9]+")) then {cat: "EC",   mode: "expand"}
        else {cat: ($name | sub("[-_:].*$"; "")), mode: "collapse"}
        end;

    def classify_ec_subkey($name):
        ($name | ascii_downcase) as $n |
        if   ($n | test("^cpu( package)?$"))             then null
        elif ($n | test("vrm|mosfet"))                   then "VRM"
        elif ($n | test("motherboard|mainboard|sysin"))  then "Mobo"
        elif ($n | test("water|coolant"))                then "Water"
        elif ($n | test("chipset|pch"))                  then "Chipset"
        else $name end;

    def extract_temp:
        . as $d |
        ([keys[] | select(test("^temp[0-9]+_input$"))][0]) as $ikey |
        if $ikey == null then null
        else
            ($ikey | sub("_input$"; "")) as $base |
            { input: $d[$ikey], crit: $d[$base + "_crit"], max: $d[$base + "_max"] }
        end;

    def cat_priority:
        ascii_downcase as $c |
        if   $c == "cpu"                then 0
        elif $c == "gpu"                then 1
        elif ($c | startswith("nvme"))  then 2
        elif ($c | startswith("ram"))   then 3
        elif $c == "vrm"                then 4
        elif $c == "mobo"               then 5
        elif $c == "water"              then 6
        elif $c == "chipset"            then 7
        else 100 end;

    def class_for($t; $crit; $maxt):
        if   ($crit | type) == "number" and $crit > 0 and $crit < 200 then
                 if $t >= $crit * 0.9 then "crit"
            elif $t >= $crit * 0.7 then "warn"
            else "" end
        elif ($maxt | type) == "number" and $maxt > 0 and $maxt < 200 then
                 if $t >= $maxt * 0.9 then "crit"
            elif $t >= $maxt * 0.7 then "warn"
            else "" end
        else
                 if $t >= 80 then "crit"
            elif $t >= 60 then "warn"
            else "" end
        end;

    def pad_to($n):
        . as $s |
        ($n - ($s | length)) as $d |
        if $d <= 0 then $s
        else $s + ([range(0; $d)] | map(" ") | add)
        end;

    def fmtT: round | tostring;

    def row_text:
        if .n > 1 and .min != .max then
            "\(.min | fmtT)~\(.max | fmtT)°C (\(.chip): \(.min_label)~\(.max_label))"
        else
            "\(.max | fmtT)°C (\(.chip))"
        end;

    [
      to_entries[] |
      .key as $chip |
      classify_chip($chip) as $cls |
      .value | to_entries[] |
      select(.value | type == "object") |
      .key as $subkey |
      (.value | extract_temp) as $t |
      select($t != null and ($t.input | type) == "number" and $t.input > -100) |
      (if $cls.mode == "expand" then classify_ec_subkey($subkey) else $cls.cat end) as $final_cat |
      select($final_cat != null) |
      {
        chip:      $chip,
        category:  $final_cat,
        sub_label: $subkey,
        temp:      $t.input,
        crit:      $t.crit,
        max_t:     $t.max
      }
    ] as $records |

    if ($records | length) == 0 then
      {text: "", tooltip: ""}
    else
      [
        $records | group_by([.category, .chip])[] |
        sort_by(.temp) as $sorted |
        ($sorted | first) as $lo |
        ($sorted | last)  as $hi |
        {
          category:  $hi.category,
          chip:      $hi.chip,
          min:       $lo.temp,
          max:       $hi.temp,
          min_label: $lo.sub_label,
          max_label: $hi.sub_label,
          n:         ($sorted | length),
          max_crit:  $hi.crit,
          max_max:   $hi.max_t
        }
      ] as $agg |

      [
        $agg | group_by(.category)[] |
        sort_by(.chip) as $g |
        ($g | length) as $n |
        $g | to_entries[] |
        .value + {
          display_category: (if $n > 1 then "\(.value.category)\(.key)" else .value.category end)
        }
      ] as $rows |

      ($rows | sort_by([(.category | cat_priority), .display_category])) as $ordered |
      ($rows | sort_by(.max) | last) as $hot |
      class_for($hot.max; $hot.max_crit; $hot.max_max) as $cls |
      ($ordered | map(.display_category | length) | max) as $catlen |
      ($catlen + 2) as $colwidth |

      ($ordered | map(
        ((.display_category + ":") | pad_to($colwidth)) + (. | row_text)
      ) | join("\n")) as $tt |

      "Temp: \($hot.max | fmtT)°C (\($hot.display_category))" as $bar |

      {text: $bar, tooltip: $tt, class: $cls}
    end
' <<< "$raw" 2>/dev/null) || noop

[[ -z "$out" ]] && noop
printf '%s\n' "$out"
