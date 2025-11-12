#!/system/bin/sh

# Module Configuration
MODID="S23U"
MODDIR="${0%/*}"

# Environment Detection
if [ -d "/data/adb/ksu/modules" ]; then
    MODPATH="/data/adb/ksu/modules/${MODID}"
    LOG_DIR="${MODPATH}/logs"
    log "KernelSU environment detected"
elif [ -d "/data/adb/modules" ]; then
    MODPATH="/data/adb/modules/${MODID}"
    LOG_DIR="${MODPATH}/logs"
    log "Magisk environment detected"
else
    MODPATH="${MODDIR}"
    LOG_DIR="/data/local/tmp/${MODID}_logs"
    log "Rooted environment (no module framework)"
fi

# Create log directory
mkdir -p "${LOG_DIR}"
LOG_FILE="${LOG_DIR}/mount.log"

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %T')] [${MODID}] $1" | tee -a "${LOG_FILE}"
}

# Mount operations
log "Starting system mounts"
for dir in "${MODDIR}/system"/*; do
    [ -d "${dir}" ] || continue
    target="/system/$(basename "${dir}")"
    
    if [ -d "${target}" ]; then
        log "Mounting: ${dir} → ${target}"
        for item in "${dir}"/*; do
            [ -e "${item}" ] || continue
            mountpoint="${target}/$(basename "${item}")"
            mkdir -p "${mountpoint}"
            if mount -o bind "${item}" "${mountpoint}"; then
                log "Mount success: ${item}"
            else
                log "Mount failed: ${item}"
            fi
        done
    else
        log "Skipped: ${target} not found"
    fi
done

log "All mounts completed"