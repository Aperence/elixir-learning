_build/prod/rel/bar/bin/bar start > /dev/null& 
_build/prod/rel/foo/bin/foo start > /dev/null& 
sleep 1
{ 
echo "CREATE bits";
echo "PUT bits sword 1";
echo "GET bits sword"; 
sleep 1; 
} | telnet 127.0.0.1 4040

sleep 1
# kill the erlang vm
ps | grep "beam.smp" | cut -f3 -d" " | xargs kill