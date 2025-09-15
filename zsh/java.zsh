export JAVA_HOME=/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home
export PATH="$JAVA_HOME/bin:$PATH"


#!/usr/bin/env zsh
# ==========================================
# Java Shortcuts (jsc) - Unified Command System
# ==========================================

# Main activation function - shows help and loads commands
jsc() {
    if [ "$1" = "help" ] || [ -z "$1" ]; then
        _jsc_help
    else
        # Execute jsc command if it exists
        local cmd="jsc-$1"
        shift
        if command -v $cmd > /dev/null 2>&1; then
            $cmd "$@"
        else
            echo "❌ Unknown command: $cmd"
            echo "Run 'jsc help' for available commands"
        fi
    fi
}

# ==========================================
# Java Management Commands (jsc-j-*)
# ==========================================
jsc-j-ls() { sdk list java | grep -E "(installed|local only)"; }
jsc-j-available() { sdk list java; }
jsc-j-use() { sdk use java $1; }
jsc-j-set() { sdk default java $1; }
jsc-j-17() { sdk use java 17.0.9-tem; }
jsc-j-11() { sdk use java 11.0.21-tem; }
jsc-j-21() { sdk use java 21.0.1-tem; }
jsc-j-version() { java -version 2>&1 | head -1; }
jsc-j-check() {
    echo "Java Setup:"
    echo "  Version: $(jsc-j-version)"
    echo "  JAVA_HOME: ${JAVA_HOME:-Not set}"
    echo "  Current SDK: $(sdk current java 2>/dev/null || echo 'N/A')"
}

# ==========================================
# Gradle Commands (jsc-g-*)
# ==========================================
jsc-g() { ./gradlew "$@"; }
jsc-g-build() { ./gradlew build; }
jsc-g-clean() { ./gradlew clean; }
jsc-g-cb() { ./gradlew clean build; }

# No test/lint variants
jsc-g-nt() { ./gradlew build -x test; }
jsc-g-ant() { ./gradlew assembleDebug -x test; }
jsc-g-fast() { ./gradlew assembleDebug -x test -x lint --parallel --offline; }

# Dependencies
jsc-g-deps() { ./gradlew dependencies; }
jsc-g-refresh() { ./gradlew --refresh-dependencies; }

# Cache
jsc-g-nocache() { ./gradlew build --no-build-cache; }
jsc-g-cleancache() { ./gradlew cleanBuildCache; }

# Android specific
jsc-g-apk() { ./gradlew assembleDebug; }
jsc-g-release() { ./gradlew assembleRelease; }
jsc-g-install() { ./gradlew installDebug; }
jsc-g-uninstall() { ./gradlew uninstallDebug; }
jsc-g-run() { 
    ./gradlew installDebug && adb shell am start -n $(jsc-g-pkg)/.MainActivity
}

# Test & Quality
jsc-g-test() { ./gradlew test; }
jsc-g-lint() { ./gradlew lint; }

# Utilities
jsc-g-tasks() { ./gradlew tasks; }
jsc-g-stop() { ./gradlew --stop && echo "✅ Gradle daemon stopped"; }
jsc-g-pkg() {
    if [ -f "app/build.gradle.kts" ]; then
        grep "applicationId" app/build.gradle.kts | sed 's/.*"\(.*\)".*/\1/' | head -1
    elif [ -f "app/build.gradle" ]; then
        grep "applicationId" app/build.gradle | sed 's/.*"\(.*\)".*/\1/' | head -1
    fi
}

# Complex operations
jsc-g-fresh() {
    echo "🧹 Full fresh build..."
    ./gradlew clean --refresh-dependencies build --no-build-cache
}

jsc-g-fix() {
    echo "🔧 Fixing Gradle issues..."
    ./gradlew clean cleanBuildCache
    ./gradlew --stop
    rm -rf ~/.gradle/caches/build-cache-*
    ./gradlew build --refresh-dependencies
}

# ==========================================
# APK Management (jsc-apk-*)
# ==========================================
jsc-apk-location() {
    echo "📦 APK locations:"
    echo "  Debug: app/build/outputs/apk/debug/app-debug.apk"
    echo "  Release: app/build/outputs/apk/release/app-release.apk"
    ls -lh app/build/outputs/apk/*/app-*.apk 2>/dev/null
}

jsc-apk-install() {
    local apk="app/build/outputs/apk/debug/app-debug.apk"
    if [ -f "$apk" ]; then
        echo "📲 Installing $apk..."
        adb install -r "$apk"
    else
        echo "❌ APK not found. Run 'jsc-g-apk' first"
    fi
}

jsc-apk-size() {
    local apk="app/build/outputs/apk/debug/app-debug.apk"
    if [ -f "$apk" ]; then
        echo "📏 APK size analysis:"
        ls -lh "$apk"
        unzip -l "$apk" | tail -1
    fi
}

# ==========================================
# Quick Workflow Commands (jsc-w-*)
# ==========================================
jsc-w-dev() {
    echo "🚀 Dev workflow: clean, build, install, run"
    jsc-g-clean
    jsc-g-fast
    jsc-g-install
    adb shell am start -n $(jsc-g-pkg)/.MainActivity
}

jsc-w-test() {
    echo "🧪 Test workflow: build and test"
    jsc-g-build
    jsc-g-test
    jsc-g-lint
}

# ==========================================
# Help System
# ==========================================
_jsc_help() {
    echo "╔════════════════════════════════════════════════════════╗"
    echo "║              Java Shortcuts (jsc) Commands            ║"
    echo "╚════════════════════════════════════════════════════════╝"
    echo ""
    echo "Usage: jsc <command> [args]"
    echo ""
    echo "Java Management (jsc-j-*):"
    echo "  jsc-j-17         Switch to Java 17"
    echo "  jsc-j-version    Show current Java version"
    echo "  jsc-j-check      Check Java setup"
    echo ""
    echo "Gradle (jsc-g-*):"
    echo "  jsc-g-build      Build project"
    echo "  jsc-g-clean      Clean build"
    echo "  jsc-g-fast       Fast build (no test/lint)"
    echo "  jsc-g-install    Install on device"
    echo "  jsc-g-run        Install and launch app"
    echo "  jsc-g-fix        Fix Gradle issues"
    echo ""
    echo "APK (jsc-apk-*):"
    echo "  jsc-apk-location Show APK paths"
    echo "  jsc-apk-install  Install APK on device"
    echo "  jsc-apk-size     Analyze APK size"
    echo ""
    echo "Workflows (jsc-w-*):"
    echo "  jsc-w-dev        Full dev cycle"
    echo "  jsc-w-test       Run all tests"
    echo ""
    echo "Type 'jsc help' to see this again"
}

# Initialize SDKMAN if available
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Show that commands are loaded
echo "✅ Java shortcuts loaded. Type 'jsc help' for commands"
