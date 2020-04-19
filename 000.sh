cat 00head `cat 001dblist` |grep -v '^%'|sed 's/^@//g' > jdata.base
