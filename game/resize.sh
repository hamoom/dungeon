DIR=$1
for f in $DIR*[^@4x^@2x].png;
  do
  NEW=${f%.png}@2x.png; convert ${f} -filter point -resize 200% "${NEW}";
  NEW=${f%.png}@4x.png; convert ${f} -filter point -resize 400% "${NEW}";
done
