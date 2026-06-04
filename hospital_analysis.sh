#!/bin/bash
# ============================================================
# KNH Hospital Analysis Script
# hospital_analysis.sh
#
# Member 5 (Clinical Analyst) : process_vitals()
# Member 6 (Facility Auditor) : water_audit()
# ============================================================

ACTIVE_LOGS="./active_logs"
REPORTS="./reports"
HEART_RATE_LOG="$ACTIVE_LOGS/heart_rate.log"
TEMP_LOG="$ACTIVE_LOGS/temperature.log"
WATER_LOG="$ACTIVE_LOGS/water_usage.log"
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

water_audit() {
    echo "============================================"
    echo "  [Member 6] Running Facility Water Audit  "
    echo "============================================"
    if [ ! -f "$WATER_LOG" ]; then
        echo "[ERROR] Water usage log not found: $WATER_LOG"
        return 1
    fi
    awk -F',' '
        /ICU_WATER_RESERVE/ {
            sum += $3
            count++
        }
        END {
            if (count == 0) {
                printf "\n  [WARNING] No ICU_WATER_RESERVE readings found.\n"
            } else {
                avg = sum / count
                printf "\n"
                printf "  ╔══════════════════════════════════════════╗\n"
                printf "  ║       KNH — ICU WATER USAGE REPORT       ║\n"
                printf "  ╠══════════════════════════════════════════╣\n"
                printf "  ║  Device        : ICU_WATER_RESERVE        ║\n"
                printf "  ║  Readings Taken: %-4d                     ║\n", count
                printf "  ║  Total Usage   : %-8.2f Liters          ║\n", sum
                printf "  ║  Average Usage : %-8.2f Liters          ║\n", avg
                printf "  ╚══════════════════════════════════════════╝\n"
                printf "\n"
            }
        }
    ' "$WATER_LOG"
    echo "[SUCCESS] Water audit complete."
    echo ""
}

echo ""
echo "########################################################"
echo "#     Kenyatta National Hospital — Analysis Engine     #"
echo "########################################################"
echo ""
process_vitals
water_audit
echo "########################################################"
echo "#              Analysis Complete                       #"
echo "########################################################"
echo ""
