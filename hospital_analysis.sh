#!/bin/bash
# ============================================================
# KNH Hospital Analysis Script
# hospital_analysis.sh
#

# Member 5 (Olga) : The clinical analyst
# Member 6 (Kambare) : The facility auditor
# Member 5 (Clinical Analyst) : process_vitals()
process_vitals() {
  echo "============================================"
    echo " MEMBER 5 - CLINICAL VITALS ANALYSIS REPORT "
    echo "============================================"

    # Ensure reports directory exists
    if [ ! -d "$REPORTS" ]; then
        mkdir -p "$REPORTS"
    fi

    > "$CRITICAL_ALERTS"

    echo "KNH Critical Alerts Report — Generated: $(date '+%Y-%m-%d %H:%M:%S')" >> "$CRITICAL_ALERTS"
    echo "------------------------------------------------------------" >> "$CRITICAL_ALERTS"
    echo "" >> "$CRITICAL_ALERTS"

    # Check if logs exist
    if [ ! -s "$HEART_RATE_LOG" ] && [ ! -s "$TEMP_LOG" ]; then
        echo "WARNING: No active critical data found in logs." >> "$CRITICAL_ALERTS"
        echo "[INFO] No data available to process."
        return 0
    fi

    # ================= HEART RATE =================
    echo "[HEART RATE — CRITICAL EVENTS]" >> "$CRITICAL_ALERTS"

    if [ -f "$HEART_RATE_LOG" ]; then
        critical_hr=$(grep "CRITICAL" "$HEART_RATE_LOG" | awk -F',' '{print $1, $2, $3}')

        hr_count=$(grep -c "CRITICAL" "$HEART_RATE_LOG")

        if [ -z "$critical_hr" ]; then
            echo "  No critical heart rate events detected." >> "$CRITICAL_ALERTS"
        else
            echo "$critical_hr" >> "$CRITICAL_ALERTS"
        fi

        echo "Total Heart Rate CRITICAL events: $hr_count" >> "$CRITICAL_ALERTS"
    else
        echo "[WARNING] Heart rate log not found." >> "$CRITICAL_ALERTS"
    fi

    echo "" >> "$CRITICAL_ALERTS"

    # ================= TEMPERATURE =================
    echo "[TEMPERATURE — CRITICAL EVENTS]" >> "$CRITICAL_ALERTS"

    if [ -f "$TEMP_LOG" ]; then
        critical_temp=$(grep "CRITICAL" "$TEMP_LOG" | awk -F',' '{print $1, $2, $3}')

        temp_count=$(grep -c "CRITICAL" "$TEMP_LOG")

        if [ -z "$critical_temp" ]; then
            echo "  No critical temperature events detected." >> "$CRITICAL_ALERTS"
        else
            echo "$critical_temp" >> "$CRITICAL_ALERTS"
        fi

        echo "Total Temperature CRITICAL events: $temp_count" >> "$CRITICAL_ALERTS"
    else
        echo "[WARNING] Temperature log not found." >> "$CRITICAL_ALERTS"
    fi

    echo "" >> "$CRITICAL_ALERTS"
    echo "============================================================" >> "$CRITICAL_ALERTS"

    echo "[SUCCESS] Critical alerts saved to: $CRITICAL_ALERTS"
    echo ""
    echo "--- Preview ---"
    cat "$CRITICAL_ALERTS"
    echo "---------------"
}
# Member 6 (Facility Auditor) : water_audit()

# ============================================================

ACTIVE_LOGS="./active_logs"
REPORTS="./reports"
HEART_RATE_LOG="$ACTIVE_LOGS/heart_rate_log.log"
TEMP_LOG="$ACTIVE_LOGS/temperature_log.log"
WATER_LOG="$ACTIVE_LOGS/water_usage_log.log"
WATER_LOG="$ACTIVE_LOGS/water_usage7_log.log"
CRITICAL_ALERTS="$REPORTS/critical_alerts.txt"

process_vitals() {
    echo "============================================"
    echo "  [Member 5] Running Clinical Vitals Check "
    echo "============================================"
    if [ ! -d "$REPORTS" ]; then
        mkdir -p "$REPORTS"
    fi
    > "$CRITICAL_ALERTS"
    echo "KNH Critical Alerts Report — Generated: $(date '+%Y-%m-%d %H:%M:%S')" >> "$CRITICAL_ALERTS"
    echo "------------------------------------------------------------" >> "$CRITICAL_ALERTS"
    echo "" >> "$CRITICAL_ALERTS"
    echo "[HEART RATE — CRITICAL EVENTS]" >> "$CRITICAL_ALERTS"
    if [ ! -f "$HEART_RATE_LOG" ]; then
        echo "[WARNING] Heart rate log not found: $HEART_RATE_LOG"
        echo "  No heart rate log found." >> "$CRITICAL_ALERTS"
    else
        critical_hr=$(grep "CRITICAL" "$HEART_RATE_LOG" | awk -F',' '{print $1, $2, $3}')
        if [ -z "$critical_hr" ]; then
            echo "  No critical heart rate events detected." >> "$CRITICAL_ALERTS"
        else
            echo "$critical_hr" >> "$CRITICAL_ALERTS"
        fi
    fi
    echo "" >> "$CRITICAL_ALERTS"
    echo "[TEMPERATURE — CRITICAL EVENTS]" >> "$CRITICAL_ALERTS"
    if [ ! -f "$TEMP_LOG" ]; then
        echo "[WARNING] Temperature log not found: $TEMP_LOG"
        echo "  No temperature log found." >> "$CRITICAL_ALERTS"
    else
        critical_temp=$(grep "CRITICAL" "$TEMP_LOG" | awk -F',' '{print $1, $2, $3}')
        if [ -z "$critical_temp" ]; then
            echo "  No critical temperature events detected." >> "$CRITICAL_ALERTS"
        else
            echo "$critical_temp" >> "$CRITICAL_ALERTS"
        fi
    fi
    echo ""
    echo "[SUCCESS] Critical alerts saved to: $CRITICAL_ALERTS"
    echo ""
    echo "--- Preview of $CRITICAL_ALERTS ---"
    cat "$CRITICAL_ALERTS"
    echo "------------------------------------"
    echo ""
}

# ==============================================================
# MEMBER 6: TAPIWANASHE KAMBARE [Facility Auditor]
#
# Reads the water usage log, filters rows for ICU_WATER_RESERVE,
# and uses awk to compute:
#   - Total readings
#   - Average, peak, and minimum consumption (L/min)
#   - Count and percentage of HIGH_USAGE events
# Prints a formatted audit summary to the screen using printf.
# ==============================================================

water_audit() {
    echo "=============================================="
    echo "  [M6] ICU Water Reserve - Facility Audit"
    echo "=============================================="
    echo ""

    # Verify the water log exists before proceeding
    if [ ! -f "$WATER_LOG" ]; then
        echo "[ERROR] Water log not found: $WATER_LOG"
        echo "        Start the Python engine first."
        return 1
    fi

    # ── AWK STATISTICS ENGINE ─────────────────────────────────
    # Pipe ICU rows into awk for a single-pass calculation.
    # -F '|'  sets pipe as the field delimiter.
    #
    # BEGIN block: initialise all accumulators before reading any line.
    # Main block:  runs once per row.
    #   gsub()    trims leading/trailing whitespace from field $3 (value)
    #             and $4 (status) because the log format is " 38 " not "38".
    #   val+0     coerces the string to a number.
    #   Conditionals track max, min, and HIGH_USAGE count.
    # END block:   prints five space-delimited results on one line so bash
    #              can read them into variables with 'read'.
    # ──────────────────────────────────────────────────────────
    local awk_result
    awk_result=$(grep "ICU_WATER_RESERVE" "$WATER_LOG" | awk -F '|' '
    BEGIN {
        sum        = 0
        count      = 0
        max_val    = 0
        min_val    = 999999
        high_usage = 0
    }
    {
        gsub(/^[[:space:]]+|[[:space:]]+$/, "", $3)   # trim value field
        gsub(/^[[:space:]]+|[[:space:]]+$/, "", $4)   # trim status field

        val = $3 + 0          # convert string to number

        if (val > 0) {
            sum  += val
            count++
            if (val > max_val) max_val = val
            if (val < min_val) min_val = val
            if ($4 == "HIGH_USAGE") high_usage++
        }
    }
    END {
        if (count > 0)
            printf "%.2f %d %.2f %.2f %d", sum/count, count, max_val, min_val, high_usage
        else
            printf "0.00 0 0.00 0.00 0"
    }')

    # Parse the five space-separated values awk returned into bash variables
    local avg count max_val min_val high_count
    read -r avg count max_val min_val high_count <<< "$awk_result"

    # Compute high-usage percentage in awk (bash can't do floating-point)
    local pct_high="0.0"
    if [ "$count" -gt 0 ]; then
        pct_high=$(awk "BEGIN { printf \"%.1f\", ($high_count / $count) * 100 }")
    fi

    echo "[INFO] awk results: avg=$avg  count=$count  max=$max_val  min=$min_val  high=$high_count"

# ── STATUS CLASSIFICATION ─────────────────────────────────
    # Convert floating-point average to integer for comparison
    # (bash arithmetic only handles integers).
    local avg_int status_label
    avg_int=$(printf "%.0f" "$avg")

    if   [ "$count" -eq 0 ];       then status_label="[?] NO DATA - No ICU readings in log yet"
    elif [ "$avg_int" -gt 35 ];    then status_label="[!] HIGH CONSUMPTION - Immediate Review Required"
    elif [ "$avg_int" -gt 25 ];    then status_label="[~] ELEVATED - Monitor Closely"
    else                                 status_label="[*] NORMAL - Within Acceptable Range"
    fi

    # ── FORMATTED AUDIT TABLE ─────────────────────────────────
    # printf "| %-48s |\n" left-aligns the string in a 48-char field.
    # The border line (50 dashes) plus the two '+' signs totals 52 chars,
    # matching "| " + 48 chars + " |" = 52 chars — so the box lines up.
    printf "\n"
    printf "+--------------------------------------------------+\n"
    printf "|         KNH WATER USAGE AUDIT REPORT            |\n"
    printf "+--------------------------------------------------+\n"
    printf "| %-48s |\n"  " Facility Device   : ICU Water Reserve"
    printf "| %-48s |\n"  " Audit Timestamp   : $(date '+%Y-%m-%d %H:%M:%S')"
    printf "+--------------------------------------------------+\n"
    printf "| %-48s |\n"  " READINGS SUMMARY"
    printf "| %-48s |\n"  "   Total Readings   : $count"
    printf "| %-48s |\n"  "   Average Usage    : $avg L/min"
    printf "| %-48s |\n"  "   Peak Usage       : $max_val L/min"
    printf "| %-48s |\n"  "   Minimum Usage    : $min_val L/min"
    printf "+--------------------------------------------------+\n"
    printf "| %-48s |\n"  " ALERT SUMMARY"
    printf "| %-48s |\n"  "   HIGH_USAGE Events: $high_count  ($pct_high% of readings)"
    printf "+--------------------------------------------------+\n"
    printf "| %-48s |\n"  " STATUS:"
    printf "| %-48s |\n"  "   $status_label"
    printf "+--------------------------------------------------+\n"
    printf "\n"

    echo "[DONE] Water audit complete."
    echo ""
}

=======
# =====================================
# Execution Logic
# =====================================

echo "====================================="
echo "KNH Hospital Analysis System"
echo "====================================="
echo "1. Process Critical Vitals"
echo "2. Water Audit"
echo "3. Run Both"
echo "4. Exit"
echo "====================================="

read -p "Enter your choice (1-4): " choice

case $choice in
    1)
        process_vitals
        ;;
    2)
        water_audit
        ;;
    3)
        process_vitals
        echo
        water_audit
        ;;
    4)
        echo "Exiting system..."
        ;;
    *)
        echo "Invalid choice. Please enter a number between 1 and 4."
        ;;
esac
