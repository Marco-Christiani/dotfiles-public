#!/bin/zsh

list_sinks(){
  pactl list short sinks | column -t
}

select_sink(){
  current_sink=$(pactl info | sed -En 's/Default Sink: (.*)/\1/p')
  # sinks=$(pactl list short sinks | grep -v "$default")
  sinks=$(pactl list short sinks | column -t)

  echo "Please choose a new sink. (Current: $current_sink)"

  choice=$(echo "$sinks" | fzf --height 20%)
  if [ -z "$choice" ]; then
    exit 0
  fi
  newsid=$(echo "$choice" | cut --delimiter " " -f1)
  echo "Changing to $newsid"
  pactl set-default-sink $newsid
}

cycle_sinks(){
  current_sink_idx=$(pactl list short sinks | awk 'BEGIN {FS="\n"} /(RUNNING)/{print NR}')

  sink_ids=($(pactl list short sinks | awk 'BEGIN {FS="\t"} {print $1}'))
  num_sinks=${#sink_ids[@]}
  if [ "$1" = '-v' ]; then
    echo "Number of sinks: $num_sinks"
    echo "Current sink : id=${sink_ids[$current_sink_idx]} idx=$current_sink_idx"
  fi

  next_sink_idx=$(expr $current_sink_idx + 1 )
  # Handle looping the array if we currently have the last sink selected
  num_sinks_p1=$(expr $num_sinks + 1)
  next_sink_idx=$(expr $num_sinks_p1 % $next_sink_idx)
  # bash starts arrays at 1 smh
  next_sink_idx=$(expr $next_sink_idx + 1) 
  # Get the ID corresponding to the index
  next_sink_id=${sink_ids[next_sink_idx]}

  if [ "$1" = '-v' ]; then
    echo "Next sink : id=$next_sink_id idx=$next_sink_idx"
    echo "Changing to $next_sink_id"
  fi

  pactl set-default-sink $next_sink_id

  # Move all sources to new default sink
  if [ "$1" = '-v' ]; then
    echo "Moving sink inputs"
  fi

  for line in "$(pactl list short sink-inputs)"
  do
  	id_stream=$(echo "$line" | cut -d'	' -f1)
  	pactl move-sink-input "$id_stream" "$next_sink_id"
  done
  sink_name=$(pactl list short sinks | awk 'BEGIN {FS="\n"} /(RUNNING)/{print $0}' | awk '{print $2}')
  notify-send -u normal "Default audio sink changed." "$sink_name"
}

show_usage() {
    printf "Usage\n\n"
    printf "Options:\n"
    printf " -c/--cycle : Cycle to next sink\n"
    printf " -l/--list : List available sinks\n"
    printf " -s/--get : Select sink with fzf\n"
    printf " -v : Be verbose (for cycle sinks)\n"
    printf " -h : help, Print help\n"
    return 0
}

while [ ! -z "$1" ]; do
  case "$1" in
     --cycle|-c)
         echo "Cycling sinks..."
         shift
         cycle_sinks $@
         if [ "$1" = "-v" ]; then
           shift
         fi
         ;;
     --list|-l)
         echo "Listing available sinks..."
         list_sinks
         shift
         ;;
     --select|-s)
         select_sink
         shift
         ;;
     *)
        show_usage
        ;;
  esac
done

# moves all sources to new default sink.

# for line in "$(pactl list short sink-inputs)"
# do
# 	id_stream=$(echo "$line" | cut -d'	' -f1)
# 	pactl move-sink-input "$id_stream" "$newsid"
# done

