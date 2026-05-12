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
