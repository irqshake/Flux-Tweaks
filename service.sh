#!/system/bin/sh

ps_ret="$(ps -Ao pid,args)"

change_task_cgroup()
{
    for temp_pid in $(echo "$ps_ret" | grep "$1" | awk '{print $1}'); do
        for temp_tid in $(ls "/proc/$temp_pid/task/"); do
            echo "$temp_tid" > "/dev/$3/$2/tasks"
        done
    done
}

mkdir /dev/cpuctl/ux_critical
echo 1 > /dev/cpuctl/ux_critical/cpu.uclamp.latency_sensitive

change_task_cgroup "surfaceflinger" "ux_critical" "cpuctl"
change_task_cgroup "vendor.qti.hardware.display.composer-service" "ux_critical" "cpuctl"
change_task_cgroup "vendor.qti.hardware.display.allocator-service" "ux_critical" "cpuctl"
change_task_cgroup "kgsl-events" "ux_critical" "cpuctl"
change_task_cgroup "kgsl_worker_thr" "ux_critical" "cpuctl"
change_task_cgroup "crtc_commit" "ux_critical" "cpuctl"
change_task_cgroup "crtc_event" "ux_critical" "cpuctl"
change_task_cgroup "pp_event" "ux_critical" "cpuctl"

# Move these to foreground cpuset instead of top-app, so they can utilise big cpu when needed and do not compete with task on the last CPU.
change_task_cgroup "surfaceflinger" "foreground" "cpuset"
change_task_cgroup "vendor.qti.hardware.display.composer-service" "foreground" "cpuset"
change_task_cgroup "vendor.qti.hardware.display.allocator-service" "foreground" "cpuset"
change_task_cgroup "kgsl-events" "foreground" "cpuset"
change_task_cgroup "kgsl_worker_thr" "foreground" "cpuset"
change_task_cgroup "crtc_commit" "foreground" "cpuset"
change_task_cgroup "crtc_event" "foreground" "cpuset"
change_task_cgroup "pp_event" "foreground" "cpuset"

# Save some juice on big cpus
change_task_cgroup ".hardware.atrace" "background" "cpuset"
change_task_cgroup ".hardware.sensors" "background" "cpuset"
change_task_cgroup ".hardware.health" "background" "cpuset"
change_task_cgroup ".hardware.lights" "background" "cpuset"
change_task_cgroup ".hardware.memtrack" "background" "cpuset"
change_task_cgroup ".hardware.thermal" "background" "cpuset"
change_task_cgroup ".hardware.usb" "background" "cpuset"
change_task_cgroup ".hardware.wifi" "background" "cpuset"
change_task_cgroup ".hardware.vibrator" "background" "cpuset"
change_task_cgroup ".hardware.gnss" "background" "cpuset"
change_task_cgroup "bluetooth" "background" "cpuset"
change_task_cgroup "fmradio" "background" "cpuset"
change_task_cgroup "logd" "background" "cpuset"
change_task_cgroup "subsystem_ramdump" "background" "cpuset"
change_task_cgroup "diag_mdlog" "background" "cpuset"
change_task_cgroup "diag-router" "background" "cpuset"
change_task_cgroup "ipacm-diag" "background" "cpuset"
change_task_cgroup "tombstoned" "background" "cpuset"
change_task_cgroup "traced" "background" "cpuset"
change_task_cgroup "statsd" "background" "cpuset"
change_task_cgroup "f2fs_gc" "background" "cpuset"
change_task_cgroup "kgsl_low_prio" "background" "cpuset"

# Do same for cpuctl
change_task_cgroup ".hardware.atrace" "background" "cpuctl"
change_task_cgroup ".hardware.sensors" "background" "cpuctl"
change_task_cgroup ".hardware.health" "background" "cpuctl"
change_task_cgroup ".hardware.lights" "background" "cpuctl"
change_task_cgroup ".hardware.memtrack" "background" "cpuctl"
change_task_cgroup ".hardware.thermal" "background" "cpuctl"
change_task_cgroup ".hardware.usb" "background" "cpuctl"
change_task_cgroup ".hardware.wifi" "background" "cpuctl"
change_task_cgroup ".hardware.vibrator" "background" "cpuctl"
change_task_cgroup ".hardware.gnss" "background" "cpuctl"
change_task_cgroup "bluetooth" "background" "cpuctl"
change_task_cgroup "fmradio" "background" "cpuctl"
change_task_cgroup "logd" "background" "cpuctl"
change_task_cgroup "subsystem_ramdump" "background" "cpuctl"
change_task_cgroup "diag_mdlog" "background" "cpuctl"
change_task_cgroup "diag-router" "background" "cpuctl"
change_task_cgroup "ipacm-diag" "background" "cpuctl"
change_task_cgroup "tombstoned" "background" "cpuctl"
change_task_cgroup "traced" "background" "cpuctl"
change_task_cgroup "statsd" "background" "cpuctl"
change_task_cgroup "f2fs_gc" "background" "cpuctl"
change_task_cgroup "kgsl_low_prio" "background" "cpuctl"

# Normal Kernel Tweaks {Already by default in flux kernel}
# Network
echo 1 > /proc/sys/net/ipv4/tcp_no_metrics_save
echo 1 > /proc/sys/net/ipv4/tcp_low_latency
echo 0 > /proc/sys/net/ipv4/tcp_timestamps

# IO
for file in /sys/block/*/queue/iostats; do
    echo "0" > "$file"
done

# VM
echo "60" > /proc/sys/vm/stat_interval

# Frequency Governor { Comment this part if your SoC is armv8.5 }
# Frequency invariant calculations are not supported on Socs less than armv8.5
# The cpufreq driver reports a minimum transition latency of 1000us. If 2 cpufreq transitions takes place within this duration then they may cause stale data to schedutil. Therefore, set minimum rate limit to 1ms.
# It is unlikely to affect performance as very rarely the gap between 2 cpufreq transitions is going to be less than 1 ms.

for file in /sys/devices/system/cpu/cpufreq/policy*/schedutil/up_rate_limit_us; do
    echo "1000" > "$file"
done

for file in /sys/devices/system/cpu/cpufreq/policy*/schedutil/down_rate_limit_us; do
    echo "2000" > "$file"
done

for file in /sys/devices/system/cpu/cpufreq/policy*/schedutil/rate_limit_us; do
    echo "1000" > "$file"
done

