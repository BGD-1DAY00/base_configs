#!/usr/bin/env zsh
# ==========================================
# Android Development Commands (and-* prefix)
# Enhanced with device targeting support
# ==========================================
# File: ~/.config/zsh/android-commands.zsh
# Description: Android development helper functions with 'and-' prefix
# Usage: Type 'and' in terminal to see all available commands
# Most commands accept optional -d <device> parameter
# ==========================================

export PATH=$HOME/android-platform-tools:$PATH
export ANDROID_HOME="$HOME/Library/Android/sdk"
export PATH="$ANDROID_HOME/emulator:$PATH"

# Color definitions for output
AND_COLOR_HEADER='\033[1;36m'  # Cyan bold
AND_COLOR_CMD='\033[1;32m'     # Green bold
AND_COLOR_DESC='\033[0;37m'    # White
AND_COLOR_WARN='\033[1;33m'    # Yellow bold
AND_COLOR_ERROR='\033[1;31m'   # Red bold
AND_COLOR_RESET='\033[0m'       # Reset

# ==========================================
# Helper Functions
# ==========================================

# Get target device - handles -d flag or uses default
_and_get_device() {
    local device=""
    
    # Check if -d flag is provided
    while [[ $# -gt 0 ]]; do
        case $1 in
            -d|--device)
                device="$2"
                shift 2
                ;;
            *)
                shift
                ;;
        esac
    done
    
    if [ -n "$device" ]; then
        echo "-s $device"
    else
        # Check if only one device is connected
        local device_count=$(adb devices | grep -v "List" | grep -v "^$" | wc -l)
        if [ $device_count -eq 0 ]; then
            echo "${AND_COLOR_ERROR}❌ No devices connected${AND_COLOR_RESET}" >&2
            echo "${AND_COLOR_WARN}Run 'and-devices' to see available devices${AND_COLOR_RESET}" >&2
            return 1
        elif [ $device_count -gt 1 ]; then
            echo "${AND_COLOR_WARN}⚠️  Multiple devices connected. Specify with -d <device>${AND_COLOR_RESET}" >&2
            and-devices-short >&2
            return 1
        fi
    fi
}

# Parse device from arguments and return remaining args
_and_parse_device() {
    local device=""
    local remaining_args=()
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            -d|--device)
                device="$2"
                shift 2
                ;;
            *)
                remaining_args+=("$1")
                shift
                ;;
        esac
    done
    
    # Export for use by calling function
    AND_DEVICE="$device"
    AND_REMAINING_ARGS=("${remaining_args[@]}")
}

# ==========================================
# Main Help Menu
# ==========================================

and() {
    echo "${AND_COLOR_HEADER}╔════════════════════════════════════════════════════════╗${AND_COLOR_RESET}"
    echo "${AND_COLOR_HEADER}║         Android Development Commands (and-*)          ║${AND_COLOR_RESET}"
    echo "${AND_COLOR_HEADER}╚════════════════════════════════════════════════════════╝${AND_COLOR_RESET}"
    echo ""
    echo "${AND_COLOR_WARN}Most commands support: -d <device> to target specific device/emulator${AND_COLOR_RESET}"
    echo ""
    echo "${AND_COLOR_HEADER}Device Management:${AND_COLOR_RESET}"
    echo "  ${AND_COLOR_CMD}and-devices${AND_COLOR_RESET}         ${AND_COLOR_DESC}List all connected devices with details${AND_COLOR_RESET}"
    echo "  ${AND_COLOR_CMD}and-device-select${AND_COLOR_RESET}   ${AND_COLOR_DESC}Interactive device selector${AND_COLOR_RESET}"
    echo "  ${AND_COLOR_CMD}and-connect${AND_COLOR_RESET}         ${AND_COLOR_DESC}Connect to device via IP${AND_COLOR_RESET}"
    echo ""
    echo "${AND_COLOR_HEADER}Emulator Management:${AND_COLOR_RESET}"
    echo "  ${AND_COLOR_CMD}and-emu-list${AND_COLOR_RESET}        ${AND_COLOR_DESC}List all AVDs with details${AND_COLOR_RESET}"
    echo "  ${AND_COLOR_CMD}and-emu${AND_COLOR_RESET} <name>      ${AND_COLOR_DESC}Start specific emulator by name${AND_COLOR_RESET}"
    echo "  ${AND_COLOR_CMD}and-emu-select${AND_COLOR_RESET}      ${AND_COLOR_DESC}Interactive emulator selector${AND_COLOR_RESET}"
    echo "  ${AND_COLOR_CMD}and-emu-phone${AND_COLOR_RESET}       ${AND_COLOR_DESC}Start phone emulator${AND_COLOR_RESET}"
    echo "  ${AND_COLOR_CMD}and-emu-tablet${AND_COLOR_RESET}      ${AND_COLOR_DESC}Start tablet emulator${AND_COLOR_RESET}"
    echo "  ${AND_COLOR_CMD}and-emu-stop${AND_COLOR_RESET}        ${AND_COLOR_DESC}Stop specific emulator${AND_COLOR_RESET}"
    echo "  ${AND_COLOR_CMD}and-emu-kill-all${AND_COLOR_RESET}    ${AND_COLOR_DESC}Stop all emulators${AND_COLOR_RESET}"
    echo ""
    echo "${AND_COLOR_HEADER}Build & Run (supports -d <device>):${AND_COLOR_RESET}"
    echo "  ${AND_COLOR_CMD}and-run${AND_COLOR_RESET}             ${AND_COLOR_DESC}Build and run on device${AND_COLOR_RESET}"
    echo "  ${AND_COLOR_CMD}and-install${AND_COLOR_RESET}         ${AND_COLOR_DESC}Install APK on device${AND_COLOR_RESET}"
    echo "  ${AND_COLOR_CMD}and-uninstall${AND_COLOR_RESET}       ${AND_COLOR_DESC}Uninstall from device${AND_COLOR_RESET}"
    echo "  ${AND_COLOR_CMD}and-clear${AND_COLOR_RESET}           ${AND_COLOR_DESC}Clear app data on device${AND_COLOR_RESET}"
    echo ""
    echo "${AND_COLOR_HEADER}Debugging (supports -d <device>):${AND_COLOR_RESET}"
    echo "  ${AND_COLOR_CMD}and-log${AND_COLOR_RESET}             ${AND_COLOR_DESC}Show logcat for device${AND_COLOR_RESET}"
    echo "  ${AND_COLOR_CMD}and-screenshot${AND_COLOR_RESET}      ${AND_COLOR_DESC}Take screenshot from device${AND_COLOR_RESET}"
    echo "  ${AND_COLOR_CMD}and-record${AND_COLOR_RESET}          ${AND_COLOR_DESC}Record video from device${AND_COLOR_RESET}"
    echo "  ${AND_COLOR_CMD}and-shell${AND_COLOR_RESET}           ${AND_COLOR_DESC}Open shell on device${AND_COLOR_RESET}"
    echo ""
    echo "${AND_COLOR_HEADER}Examples:${AND_COLOR_RESET}"
    echo "  ${AND_COLOR_CMD}and-run -d emulator-5554${AND_COLOR_RESET}        # Run on specific emulator"
    echo "  ${AND_COLOR_CMD}and-log -d RZ8N920XQWN${AND_COLOR_RESET}          # View logs from specific device"
    echo "  ${AND_COLOR_CMD}and-emu Pixel_7_API_34${AND_COLOR_RESET}          # Start specific AVD"
}

# ==========================================
# Device Management Commands
# ==========================================

# List all devices with detailed info
and-devices() {
    echo "${AND_COLOR_HEADER}📱 Connected Devices:${AND_COLOR_RESET}"
    echo ""
    
    local devices=$(adb devices -l | grep -v "List of devices" | grep -v "^$")
    
    if [ -z "$devices" ]; then
        echo "${AND_COLOR_WARN}No devices connected${AND_COLOR_RESET}"
        echo ""
        echo "Options:"
        echo "  • Connect a physical device via USB"
        echo "  • Start an emulator with ${AND_COLOR_CMD}and-emu <name>${AND_COLOR_RESET}"
        echo "  • Connect via WiFi with ${AND_COLOR_CMD}and-connect <IP:PORT>${AND_COLOR_RESET}"
        return
    fi
    
    # Parse and display device info
    echo "$devices" | while IFS= read -r line; do
        local device_id=$(echo $line | awk '{print $1}')
        local status=$(echo $line | awk '{print $2}')
        
        # Get additional device info
        if [ "$status" = "device" ]; then
            local model=$(adb -s $device_id shell getprop ro.product.model 2>/dev/null | tr -d '\r')
            local android=$(adb -s $device_id shell getprop ro.build.version.release 2>/dev/null | tr -d '\r')
            local brand=$(adb -s $device_id shell getprop ro.product.brand 2>/dev/null | tr -d '\r')
            
            echo "${AND_COLOR_CMD}Device ID:${AND_COLOR_RESET} $device_id"
            echo "  Model: $brand $model"
            echo "  Android: $android"
            echo "  Status: $status"
            
            # Check if it's an emulator
            if [[ $device_id == emulator-* ]]; then
                local avd_name=$(adb -s $device_id emu avd name 2>/dev/null | tr -d '\r')
                echo "  Type: Emulator (AVD: $avd_name)"
            else
                echo "  Type: Physical Device"
            fi
            echo ""
        else
            echo "${AND_COLOR_WARN}Device ID:${AND_COLOR_RESET} $device_id"
            echo "  Status: $status"
            echo ""
        fi
    done
}

# Short device list for selection
and-devices-short() {
    local devices=$(adb devices | grep -v "List of devices" | grep -v "^$" | awk '{print $1}')
    
    if [ -n "$devices" ]; then
        echo "${AND_COLOR_HEADER}Available devices:${AND_COLOR_RESET}"
        echo "$devices" | while read device; do
            local model=$(adb -s $device shell getprop ro.product.model 2>/dev/null | tr -d '\r')
            echo "  • $device ($model)"
        done
    fi
}

# Interactive device selector
and-device-select() {
    local devices=($(adb devices | grep -v "List of devices" | grep -v "^$" | awk '{print $1}'))
    
    if [ ${#devices[@]} -eq 0 ]; then
        echo "${AND_COLOR_ERROR}No devices connected${AND_COLOR_RESET}"
        return 1
    fi
    
    if [ ${#devices[@]} -eq 1 ]; then
        echo "Selected: ${devices[1]}"
        export ANDROID_SERIAL=${devices[1]}
        return 0
    fi
    
    echo "${AND_COLOR_HEADER}Select a device:${AND_COLOR_RESET}"
    local i=1
    for device in "${devices[@]}"; do
        local model=$(adb -s $device shell getprop ro.product.model 2>/dev/null | tr -d '\r')
        echo "  $i) $device ($model)"
        ((i++))
    done
    
    read "selection?Enter number: "
    
    if [[ $selection -ge 1 && $selection -le ${#devices[@]} ]]; then
        export ANDROID_SERIAL=${devices[$selection]}
        echo "Selected: $ANDROID_SERIAL"
    else
        echo "${AND_COLOR_ERROR}Invalid selection${AND_COLOR_RESET}"
        return 1
    fi
}

# ==========================================
# Emulator Management Commands
# ==========================================

# List all AVDs with details
and-emu-list() {
    echo "${AND_COLOR_HEADER}📱 Available AVDs (Android Virtual Devices):${AND_COLOR_RESET}"
    echo ""
    
    local avds=$(emulator -list-avds)
    
    if [ -z "$avds" ]; then
        echo "${AND_COLOR_WARN}No AVDs found${AND_COLOR_RESET}"
        echo ""
        echo "Create one with Android Studio or:"
        echo "  ${AND_COLOR_CMD}and-emu-create phone${AND_COLOR_RESET}   # Create phone AVD"
        echo "  ${AND_COLOR_CMD}and-emu-create tablet${AND_COLOR_RESET}  # Create tablet AVD"
        return
    fi
    
    # Check which are running
    local running_emus=$(adb devices | grep emulator | awk '{print $1}')
    
    echo "$avds" | while read avd; do
        echo "${AND_COLOR_CMD}• $avd${AND_COLOR_RESET}"
        
        # Check if running
        for emu in $running_emus; do
            local running_avd=$(adb -s $emu emu avd name 2>/dev/null | tr -d '\r')
            if [ "$running_avd" = "$avd" ]; then
                echo "  ${AND_COLOR_WARN}Status: Running on $emu${AND_COLOR_RESET}"
            fi
        done
        
        # Get AVD info if available
        local avd_path="$HOME/.android/avd/${avd}.ini"
        if [ -f "$avd_path" ]; then
            local path=$(grep "path=" "$avd_path" | cut -d'=' -f2)
            local config="$path/config.ini"
            if [ -f "$config" ]; then
                local api=$(grep "image.sysdir.1=" "$config" | grep -o "android-[0-9]*" | cut -d'-' -f2)
                local arch=$(grep "abi.type=" "$config" | cut -d'=' -f2)
                [ -n "$api" ] && echo "  API Level: $api"
                [ -n "$arch" ] && echo "  Architecture: $arch"
            fi
        fi
        echo ""
    done
}

# Start specific emulator
and-emu() {
    if [ -z "$1" ]; then
        and-emu-list
        echo "${AND_COLOR_HEADER}Usage:${AND_COLOR_RESET}"
        echo "  ${AND_COLOR_CMD}and-emu <avd-name>${AND_COLOR_RESET}      # Start specific AVD"
        echo "  ${AND_COLOR_CMD}and-emu-select${AND_COLOR_RESET}          # Interactive selector"
        return
    fi
    
    local avd="$1"
    shift
    
    # Check if AVD exists
    if ! emulator -list-avds | grep -q "^$avd$"; then
        echo "${AND_COLOR_ERROR}❌ AVD '$avd' not found${AND_COLOR_RESET}"
        echo ""
        echo "Available AVDs:"
        emulator -list-avds | while read a; do
            echo "  • $a"
        done
        return 1
    fi
    
    # Parse additional emulator options
    local emu_opts=""
    while [[ $# -gt 0 ]]; do
        case $1 in
            --fast)
                emu_opts="$emu_opts -gpu host -no-snapshot-load"
                shift
                ;;
            --clean)
                emu_opts="$emu_opts -wipe-data"
                shift
                ;;
            --headless)
                emu_opts="$emu_opts -no-window"
                shift
                ;;
            *)
                emu_opts="$emu_opts $1"
                shift
                ;;
        esac
    done
    
    echo "🚀 Starting emulator: $avd"
    [ -n "$emu_opts" ] && echo "   Options: $emu_opts"
    
    emulator -avd $avd $emu_opts &
}

# Interactive emulator selector
and-emu-select() {
    local avds=($(emulator -list-avds))
    
    if [ ${#avds[@]} -eq 0 ]; then
        echo "${AND_COLOR_ERROR}No AVDs found${AND_COLOR_RESET}"
        return 1
    fi
    
    echo "${AND_COLOR_HEADER}Select an AVD to start:${AND_COLOR_RESET}"
    local i=1
    for avd in "${avds[@]}"; do
        echo "  $i) $avd"
        ((i++))
    done
    
    read "selection?Enter number: "
    
    if [[ $selection -ge 1 && $selection -le ${#avds[@]} ]]; then
        and-emu "${avds[$selection]}"
    else
        echo "${AND_COLOR_ERROR}Invalid selection${AND_COLOR_RESET}"
        return 1
    fi
}

# Stop specific emulator
and-emu-stop() {
    if [ -z "$1" ]; then
        # Show running emulators
        local running=$(adb devices | grep emulator | awk '{print $1}')
        if [ -z "$running" ]; then
            echo "${AND_COLOR_WARN}No emulators running${AND_COLOR_RESET}"
            return
        fi
        
        echo "${AND_COLOR_HEADER}Running emulators:${AND_COLOR_RESET}"
        echo "$running" | while read emu; do
            local avd=$(adb -s $emu emu avd name 2>/dev/null | tr -d '\r')
            echo "  • $emu (AVD: $avd)"
        done
        echo ""
        echo "Usage: ${AND_COLOR_CMD}and-emu-stop <emulator-id>${AND_COLOR_RESET}"
        return
    fi
    
    echo "🛑 Stopping emulator: $1"
    adb -s $1 emu kill
}

# Kill all emulators
and-emu-kill-all() {
    echo "🛑 Stopping all emulators..."
    adb devices | grep emulator | cut -f1 | while read emu; do
        echo "  Stopping: $emu"
        adb -s $emu emu kill
    done
    
    # Also kill process if adb doesn't work
    pkill -f "qemu-system" 2>/dev/null
    echo "✅ All emulators stopped"
}

# ==========================================
# Build & Run Commands (with device targeting)
# ==========================================

and-run() {
    _and_parse_device "$@"
    local device_opt=""
    
    if [ -n "$AND_DEVICE" ]; then
        device_opt="-s $AND_DEVICE"
        echo "🎯 Target device: $AND_DEVICE"
    else
        # Check device availability
        local device_check=$(_and_get_device)
        if [ $? -ne 0 ]; then
            return 1
        fi
        device_opt="$device_check"
    fi
    
    echo "🚀 Building and running debug app..."
    ./gradlew installDebug && \
    adb $device_opt shell am start -n $(and-pkg)/.MainActivity
}

and-install() {
    _and_parse_device "$@"
    local device_opt=""
    local apk_path="${AND_REMAINING_ARGS[1]}"
    
    if [ -n "$AND_DEVICE" ]; then
        device_opt="-s $AND_DEVICE"
        echo "🎯 Target device: $AND_DEVICE"
    else
        local device_check=$(_and_get_device)
        if [ $? -ne 0 ]; then
            return 1
        fi
        device_opt="$device_check"
    fi
    
    if [ -n "$apk_path" ]; then
        echo "📲 Installing APK: $apk_path"
        adb $device_opt install -r "$apk_path"
    else
        echo "📲 Installing debug APK..."
        ./gradlew installDebug
    fi
}

and-uninstall() {
    _and_parse_device "$@"
    local device_opt=""
    
    if [ -n "$AND_DEVICE" ]; then
        device_opt="-s $AND_DEVICE"
        echo "🎯 Target device: $AND_DEVICE"
    else
        local device_check=$(_and_get_device)
        if [ $? -ne 0 ]; then
            return 1
        fi
        device_opt="$device_check"
    fi
    
    local pkg=$(and-pkg)
    echo "🗑️ Uninstalling: $pkg"
    adb $device_opt uninstall $pkg
}

and-clear() {
    _and_parse_device "$@"
    local device_opt=""
    
    if [ -n "$AND_DEVICE" ]; then
        device_opt="-s $AND_DEVICE"
        echo "🎯 Target device: $AND_DEVICE"
    else
        local device_check=$(_and_get_device)
        if [ $? -ne 0 ]; then
            return 1
        fi
        device_opt="$device_check"
    fi
    
    local pkg=$(and-pkg)
    echo "🗑️ Clearing app data for: $pkg"
    adb $device_opt shell pm clear $pkg
}

# ==========================================
# Debugging Commands (with device targeting)
# ==========================================

and-log() {
    _and_parse_device "$@"
    local device_opt=""
    local filter="${AND_REMAINING_ARGS[1]}"
    
    if [ -n "$AND_DEVICE" ]; then
        device_opt="-s $AND_DEVICE"
        echo "🎯 Target device: $AND_DEVICE"
    else
        local device_check=$(_and_get_device)
        if [ $? -ne 0 ]; then
            return 1
        fi
        device_opt="$device_check"
    fi
    
    if [ -n "$filter" ]; then
        echo "📋 Showing logs with filter: $filter (Ctrl+C to stop)"
        adb $device_opt logcat | grep "$filter"
    else
        local pkg=$(and-pkg 2>/dev/null)
        if [ -n "$pkg" ]; then
            echo "📋 Showing logs for: $pkg (Ctrl+C to stop)"
            local pid=$(adb $device_opt shell pidof $pkg)
            if [ -n "$pid" ]; then
                adb $device_opt logcat --pid=$pid
            else
                echo "${AND_COLOR_WARN}App not running. Showing all logs...${AND_COLOR_RESET}"
                adb $device_opt logcat
            fi
        else
            echo "📋 Showing all logs (Ctrl+C to stop)"
            adb $device_opt logcat
        fi
    fi
}

and-screenshot() {
    _and_parse_device "$@"
    local device_opt=""
    local filename="${AND_REMAINING_ARGS[1]:-screenshot_$(date +%Y%m%d_%H%M%S).png}"
    
    if [ -n "$AND_DEVICE" ]; then
        device_opt="-s $AND_DEVICE"
        echo "🎯 Target device: $AND_DEVICE"
    else
        local device_check=$(_and_get_device)
        if [ $? -ne 0 ]; then
            return 1
        fi
        device_opt="$device_check"
    fi
    
    echo "📸 Taking screenshot..."
    adb $device_opt exec-out screencap -p > "$filename"
    echo "✅ Screenshot saved: $filename"
}

and-record() {
    _and_parse_device "$@"
    local device_opt=""
    local duration="${AND_REMAINING_ARGS[1]}"
    
    if [ -n "$AND_DEVICE" ]; then
        device_opt="-s $AND_DEVICE"
        echo "🎯 Target device: $AND_DEVICE"
    else
        local device_check=$(_and_get_device)
        if [ $? -ne 0 ]; then
            return 1
        fi
        device_opt="$device_check"
    fi
    
    local filename="recording_$(date +%Y%m%d_%H%M%S).mp4"
    
    if [ -n "$duration" ]; then
        echo "🎥 Recording for $duration seconds..."
        adb $device_opt shell screenrecord --time-limit $duration /sdcard/recording.mp4
    else
        echo "🎥 Starting screen recording (max 3 minutes)..."
        echo "Press Ctrl+C to stop"
        adb $device_opt shell screenrecord /sdcard/recording.mp4
    fi
    
    adb $device_opt pull /sdcard/recording.mp4 "$filename"
    adb $device_opt shell rm /sdcard/recording.mp4
    echo "✅ Video saved: $filename"
}

and-shell() {
    _and_parse_device "$@"
    local device_opt=""
    
    if [ -n "$AND_DEVICE" ]; then
        device_opt="-s $AND_DEVICE"
        echo "🎯 Opening shell on: $AND_DEVICE"
    else
        local device_check=$(_and_get_device)
        if [ $? -ne 0 ]; then
            return 1
        fi
        device_opt="$device_check"
    fi
    
    adb $device_opt shell
}

# ==========================================
# Package info commands
# ==========================================

and-pkg() {
    # Try to extract package name from build.gradle or AndroidManifest
    if [ -f "app/build.gradle.kts" ]; then
        grep "applicationId" app/build.gradle.kts | sed 's/.*"\(.*\)".*/\1/' | head -1
    elif [ -f "app/build.gradle" ]; then
        grep "applicationId" app/build.gradle | sed 's/.*"\(.*\)".*/\1/' | head -1
    elif [ -f "app/src/main/AndroidManifest.xml" ]; then
        grep "package=" app/src/main/AndroidManifest.xml | sed 's/.*package="\([^"]*\)".*/\1/'
    else
        echo "com.example.app"  # fallback
    fi
}

and-pkg-info() {
    _and_parse_device "$@"
    local device_opt=""
    
    if [ -n "$AND_DEVICE" ]; then
        device_opt="-s $AND_DEVICE"
        echo "🎯 Target device: $AND_DEVICE"
    else
        local device_check=$(_and_get_device)
        if [ $? -ne 0 ]; then
            return 1
        fi
        device_opt="$device_check"
    fi
    
    local pkg=$(and-pkg)
    echo "📦 Package info for: $pkg"
    adb $device_opt shell dumpsys package $pkg | grep -E "versionCode|versionName|userId|firstInstallTime|lastUpdateTime"
}

# ==========================================
# Build Commands (no device needed)
# ==========================================

and-build() {
    echo "🔨 Building debug APK..."
    ./gradlew assembleDebug
    echo "✅ APK location: app/build/outputs/apk/debug/"
}

and-release() {
    echo "📦 Building release APK..."
    ./gradlew assembleRelease
    echo "✅ APK location: app/build/outputs/apk/release/"
}

and-clean() {
    echo "🧹 Cleaning build files..."
    ./gradlew clean
}

and-rebuild() {
    echo "♻️ Clean rebuilding project..."
    ./gradlew clean assembleDebug
}

# ==========================================
# Testing Commands
# ==========================================

and-test() {
    echo "🧪 Running all tests..."
    ./gradlew test
}

and-test-unit() {
    echo "🧪 Running unit tests..."
    ./gradlew testDebugUnitTest
}

and-test-ui() {
    _and_parse_device "$@"
    local device_opt=""
    
    if [ -n "$AND_DEVICE" ]; then
        # Gradle doesn't use -s flag, uses different mechanism
        echo "🎯 Target device: $AND_DEVICE"
        export ANDROID_SERIAL="$AND_DEVICE"
    fi
    
    echo "🧪 Running UI tests..."
    ./gradlew connectedAndroidTest
    
    unset ANDROID_SERIAL
}

# ==========================================
# Advanced Features
# ==========================================

# Connect to device over WiFi
and-connect() {
    local ip="$1"
    
    if [ -z "$ip" ]; then
        echo "${AND_COLOR_HEADER}Connect to device via WiFi${AND_COLOR_RESET}"
        echo ""
        echo "Usage: ${AND_COLOR_CMD}and-connect <IP:PORT>${AND_COLOR_RESET}"
        echo "Example: and-connect 192.168.1.100:5555"
        echo ""
        echo "Setup steps:"
        echo "  1. Connect device via USB"
        echo "  2. Run: adb tcpip 5555"
        echo "  3. Disconnect USB"
        echo "  4. Run: and-connect <device-ip>:5555"
        return
    fi
    
    echo "📡 Connecting to $ip..."
    adb connect "$ip"
}

# Quick device info
and-info() {
    _and_parse_device "$@"
    local device_opt=""
    
    if [ -n "$AND_DEVICE" ]; then
        device_opt="-s $AND_DEVICE"
        echo "🎯 Device: $AND_DEVICE"
    else
        local device_check=$(_and_get_device)
        if [ $? -ne 0 ]; then
            return 1
        fi
        device_opt="$device_check"
    fi
    
    echo "${AND_COLOR_HEADER}Device Information:${AND_COLOR_RESET}"
    echo ""
    
    # Basic info
    local brand=$(adb $device_opt shell getprop ro.product.brand | tr -d '\r')
    local model=$(adb $device_opt shell getprop ro.product.model | tr -d '\r')
    local android=$(adb $device_opt shell getprop ro.build.version.release | tr -d '\r')
    local sdk=$(adb $device_opt shell getprop ro.build.version.sdk | tr -d '\r')
    local abi=$(adb $device_opt shell getprop ro.product.cpu.abi | tr -d '\r')
    
    echo "Device: $brand $model"
    echo "Android: $android (API $sdk)"
    echo "Architecture: $abi"
    
    # Screen info
    local density=$(adb $device_opt shell wm density | grep -o "[0-9]*" | head -1)
    local size=$(adb $device_opt shell wm size | grep -o "[0-9]*x[0-9]*" | head -1)
    echo "Screen: $size @ ${density}dpi"
    
    # Storage
    local storage=$(adb $device_opt shell df /data | tail -1 | awk '{print $2 " used, " $4 " free"}')
    echo "Storage: $storage"
    
    # Battery (if available)
    local battery=$(adb $device_opt shell dumpsys battery | grep level | grep -o "[0-9]*")
    [ -n "$battery" ] && echo "Battery: ${battery}%"
}

# ==========================================
# Check setup
# ==========================================

and-check() {
    echo "🔍 Checking Android development setup..."
    echo ""
    
    # Check ANDROID_HOME
    if [ -n "$ANDROID_HOME" ]; then
        echo "✅ ANDROID_HOME: $ANDROID_HOME"
    else
        echo "❌ ANDROID_HOME not set"
    fi
    
    # Check emulator
    if command -v emulator &> /dev/null; then
        echo "✅ Emulator: $(which emulator)"
        local avd_count=$(emulator -list-avds 2>/dev/null | wc -l)
        echo "   AVDs available: $avd_count"
    else
        echo "❌ Emulator not found in PATH"
    fi
    
    # Check adb
    if command -v adb &> /dev/null; then
        echo "✅ ADB: $(which adb)"
        echo "   Version: $(adb version | head -1)"
    else
        echo "❌ ADB not found in PATH"
    fi
    
    # Check for gradle wrapper
    if [ -f "./gradlew" ]; then
        echo "✅ Gradle wrapper found"
    else
        echo "⚠️  No gradlew in current directory"
    fi
    
    # Check connected devices
    if command -v adb &> /dev/null; then
        local device_count=$(adb devices | grep -v "List" | grep -v "^$" | wc -l)
        if [ $device_count -gt 0 ]; then
            echo "✅ Connected devices: $device_count"
            and-devices-short
        else
            echo "⚠️  No devices connected"
        fi
    fi
}

# Alias for quick access
alias andp='cd ~/AndroidStudioProjects'
