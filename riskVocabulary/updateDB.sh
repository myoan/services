#! /bin/bash

if test -e ~/Downloads/Untitled\ spreadsheet\ -\ Sheet1.csv; then
	mv ~/Downloads/Untitled\ spreadsheet\ -\ Sheet1.csv ./misc/risk_key_map.csv
fi
minikonoha misc/db_init.k
mysql -u root -p --default-character-set=utf8 alertme_moc < ./misc/alertme_moc.sql
minikonoha misc/data_importer.k
