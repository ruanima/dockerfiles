# statifier
create static linked binary from dynamic linked library.

## requirement
turn off randomize_va_space `echo 0 > /proc/sys/kernel/randomize_va_space`

## current status
Not work well, `Segmentation fault (core dumped)` occors in many distro.
It seems to work on the distro which is same as statifier docker image.
