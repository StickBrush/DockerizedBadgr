docker build -t my/badgr .

docker run --rm --name badgr -p 127.0.0.1:8000:8000 my/badgr