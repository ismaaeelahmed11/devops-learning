# Process Management Notes

## Viewing Processes
ps aux
ps aux | grep nginx

ps aux shows all running processes with user, PID, CPU and memory usage. Piping into grep filters for specific processes.

## Real-Time Monitoring
top
htop

top shows live process updates. htop is a more user-friendly version with colour and scrolling.

## Background Processes
sleep 100 &
jobs
fg %1
bg %1

- & runs a command in the background
- jobs lists background processes
- fg %1 brings job 1 to the foreground
- bg %1 sends it back to the background

## Killing Processes
kill <PID>
killall sleep

kill sends a termination signal to a specific PID. killall kills all processes by name.

## Exercise: Background Process, Find PID, Kill It
sleep 300 &
ps aux | grep sleep
kill <PID>

Steps taken:
1. Started sleep 300 in the background with &
2. Used ps aux | grep sleep to find its PID
3. Used kill <PID> to terminate it
4. Verified with ps aux | grep sleep that it was gone
