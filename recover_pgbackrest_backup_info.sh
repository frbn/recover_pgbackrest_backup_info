#! /bin/bash
#
set -o errexit -o nounset

recover=${1:-"backup.info.recover"}
echo "Recovering backup manifests into $recover"

head -3 latest/backup.manifest > "$recover"
echo " " >> "$recover"

echo "[backup:current]">> "$recover"

for backup in $(ls -d ????????-??????F*)
do
	echo "$backup"
	echo -n "$backup" >> "$recover"
	echo -n '={' >> "$recover"
	for param in $(grep '=' "$backup"/backup.manifest| grep -v 'pg_data' | sed 's/=/:/')
	do
		echo -n '"' >> "$recover"
		echo -n "$param" >> "$recover"
		echo -n ',' >> "$recover"
	done
	echo '}' >> "$recover"
done

sed -i 's/,\}$/}/'  "$recover"
