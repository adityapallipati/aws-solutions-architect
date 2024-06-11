## Create our bucket
```sh
aws s3 mb s3://prefixes-fun-ap-12345
```

## Create our folder
```sh
aws s3api put-object --bucket prefixes-fun-ap-12345 --key="hello/"
```

## Create many folders
```sh
aws s3api put-object --bucket="prefixes-fun-ap-12345" --key="Lorem/ipsum/dolor/sit/amet/consectetur/adipiscing/elit/Mauris/vulputate/lectus/quis/lacus/bibendum/vel/sodales/ipsum/pellentesque/Pellentesque/habitant/morbi/tristique/senectus/et/netus/et/malesuada/fames/ac/turpis/egestas/Phasellus/semper/ex/eget/ante/ornare/nec/consequat/arcu/malesuada/Duis/cursus/erat/ipsum/id/ullamcorper/nisl/faucibus/sed/Cras/ultrices/condimentum/ligula/posuere/dignissim/felis/finibus/ac/Suspendisse/tincidunt/neque/lacus/semper/venenatis/augue/vulputate/at/Nunc/rutrum/malesuada/libero/at/luctus/eros/consequat/ut/In/dignissim/eros/eu/lorem/egestas/faucibus/Nullam/imperdiet/purus/mi/non/scelerisque/justo/semper/quis/Nam/sit/amet/sodales/libero/et/ornare/justo/Mauris/erat/dolor/consectetur/ac/erat/eu/egestas/placerat/mauris/Fusce/condimentum/at/est/at/tempus/Duis/quis/nulla/sit/amet/libero/malesuada/interdum/quis/vel/urna/Nulla/ut/nisi/mi/Lorem/ipsum/dolor/sit/amet/consectetur/adipiscing/elit/Sed/eget/gravida/nulla/Nam/vitae/mattis/dui/Cras/malesuada/nulla/eget/many/many/many/objects/s3api/"
```

## Try and break the 1024 limit
```sh
aws s3api put-object --bucket="prefixes-fun-ap-12345" --key="Lorem/ipsum/dolor/sit/amet/consectetur/adipiscing/elit/Mauris/vulputate/lectus/quis/lacus/bibendum/vel/sodales/ipsum/pellentesque/Pellentesque/habitant/morbi/tristique/senectus/et/netus/et/malesuada/fames/ac/turpis/egestas/Phasellus/semper/ex/eget/ante/ornare/nec/consequat/arcu/malesuada/Duis/cursus/erat/ipsum/id/ullamcorper/nisl/faucibus/sed/Cras/ultrices/condimentum/ligula/posuere/dignissim/felis/finibus/ac/Suspendisse/tincidunt/neque/lacus/semper/venenatis/augue/vulputate/at/Nunc/rutrum/malesuada/libero/at/luctus/eros/consequat/ut/In/dignissim/eros/eu/lorem/egestas/faucibus/Nullam/imperdiet/purus/mi/non/scelerisque/justo/semper/quis/Nam/sit/amet/sodales/libero/et/ornare/justo/Mauris/erat/dolor/consectetur/ac/erat/eu/egestas/placerat/mauris/Fusce/condimentum/at/est/at/tempus/Duis/quis/nulla/sit/amet/libero/malesuada/interdum/quis/vel/urna/Nulla/ut/nisi/mi/Lorem/ipsum/dolor/sit/amet/consectetur/adipiscing/elit/Sed/eget/gravida/nulla/Nam/vitae/mattis/dui/Cras/malesuada/nulla/eget/many/many/many/objects/s3api/hello.txt" --body="hello.txt"
```

# OUTPUT
```sh
An error occurred (KeyTooLongError) when calling the PutObject operation: Your key is too long
```

## Clean Up

```sh
../bash-scripts/delete-objects prefixes-fun-ap-12345
../bash-scripts/delete-bucket prefixes-fun-ap-12345
```