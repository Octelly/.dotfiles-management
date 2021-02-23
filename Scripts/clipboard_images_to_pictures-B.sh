clipnotify=/home/johnystar/git/clipnotify/clipnotify
screenshot_folder=/home/johnystar/Pictures

while $clipnotify;
do
	clipboard=$(xclip -selection clipboard -t image/png -o)

	clipboard_trash=$clipboard #clipboard gets converted to ascii when string comparison occurs

	if [ ! -z "$clipboard_trash" ]
	then
		latest_file=$(ls -Art $screenshot_folder | tail -n 1)
		latest_file_contents=$(cat $screenshot_folder/$latest_file)

		clipboard_trash=$clipboard #clipboard gets converted to ascii when string comparison occurs

		if [ "x$clipboard_trash" != "x$latest_file_contents" ]
		then
			formatted_date=$(date +"%Y-%m-%d-%H-%M-%S")
			echo $clipboard > "$screenshot_folder/$formatted_date.png"
		fi
	fi
done
