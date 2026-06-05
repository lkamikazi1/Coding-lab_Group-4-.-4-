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
HEART_RATE_LOG="$ACTIVE_LOGS/heart_rate_log.log"
TEMP_LOG="$ACTIVE_LOGS/temperature_log.log"
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

    # Filter only ICU_WATER_RESERVE rows from the water log.
    # The log contains two devices; we isolate the one we care about.
    echo "[INFO] Filtering ICU_WATER_RESERVE entries..."
    local icu_rows
    icu_rows=$(grep "ICU_WATER_RESERVE" "$WATER_LOG")

    echo "[INFO] Sample of ICU rows found:"
    echo "$icu_rows" | head -5
    echo ""

    echo "[INFO] Commit 1 complete - grep filter working."
}

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
