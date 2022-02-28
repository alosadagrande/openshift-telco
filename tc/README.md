# Scripts

## Example of a simple upgrade

```sh
./check-upgrade-time.sh 
Upgrade started at: Mon Feb 28 01:17:32 PM CET 2022
version 4.9.12 True True 13s Working towards 4.9.19: 9 of 738 done (1% complete)
version 4.9.12 True True 44s Working towards 4.9.19: 71 of 738 done (9% complete)
The connection to the server api.cnfdc8.sno.e2e.bos.redhat.com:6443 was refused - did you specify the right host or port?

version 4.9.12 True True 2m30s Working towards 4.9.19: 71 of 738 done (9% complete)
version 4.9.12 True True 3m1s Working towards 4.9.19: 96 of 738 done (13% complete)
version 4.9.12 True True 3m31s Working towards 4.9.19: 96 of 738 done (13% complete)
version 4.9.12 True True 4m6s Working towards 4.9.19: 96 of 738 done (13% complete)
version 4.9.12 True True 4m36s Working towards 4.9.19: 116 of 738 done (15% complete)
version 4.9.12 True True 5m7s Working towards 4.9.19: 116 of 738 done (15% complete)
version 4.9.12 True True 5m38s Working towards 4.9.19: 116 of 738 done (15% complete)
version 4.9.12 True True 6m9s Working towards 4.9.19: 142 of 738 done (19% complete), waiting on cloud-controller-manager
version 4.9.12 True True 6m39s Working towards 4.9.19: 142 of 738 done (19% complete)
version 4.9.12 True True 7m10s Working towards 4.9.19: 142 of 738 done (19% complete)
version 4.9.12 True True 7m41s Working towards 4.9.19: 142 of 738 done (19% complete)
version 4.9.12 True True 8m11s Working towards 4.9.19: 142 of 738 done (19% complete)
version 4.9.12 True True 8m42s Working towards 4.9.19: 142 of 738 done (19% complete)
version 4.9.12 True True 9m13s Working towards 4.9.19: 142 of 738 done (19% complete)
version 4.9.12 True True 9m43s Working towards 4.9.19: 203 of 738 done (27% complete)
version 4.9.12 True True 10m Working towards 4.9.19: 203 of 738 done (27% complete)
version 4.9.12 True True 10m Working towards 4.9.19: 203 of 738 done (27% complete)
version 4.9.12 True True 11m Working towards 4.9.19: 203 of 738 done (27% complete)
version 4.9.12 True True 11m Working towards 4.9.19: 207 of 738 done (28% complete)
version 4.9.12 True True 12m Working towards 4.9.19: 207 of 738 done (28% complete)
version 4.9.12 True True 12m Working towards 4.9.19: 208 of 738 done (28% complete), waiting on machine-api
version 4.9.12 True True 13m Working towards 4.9.19: 208 of 738 done (28% complete), waiting on machine-api
version 4.9.12 True True 13m Working towards 4.9.19: 235 of 738 done (31% complete)
version 4.9.12 True True 14m Working towards 4.9.19: 235 of 738 done (31% complete)
version 4.9.12 True True 14m Working towards 4.9.19: 235 of 738 done (31% complete)
version 4.9.12 True True 15m Working towards 4.9.19: 235 of 738 done (31% complete)
version 4.9.12 True True 15m Working towards 4.9.19: 235 of 738 done (31% complete)
version 4.9.12 True True 16m Working towards 4.9.19: 235 of 738 done (31% complete)
version 4.9.12 True True 16m Working towards 4.9.19: 516 of 738 done (69% complete)
version 4.9.12 True True 17m Working towards 4.9.19: 525 of 738 done (71% complete)
version 4.9.12 True True 17m Working towards 4.9.19: 530 of 738 done (71% complete)
version 4.9.12 True True 18m Working towards 4.9.19: 570 of 738 done (77% complete)
version 4.9.12 True True 18m Unable to apply 4.9.19: an unknown error has occurred: MultipleErrors
version 4.9.12 True True 19m Unable to apply 4.9.19: an unknown error has occurred: MultipleErrors
version 4.9.12 True True 19m Unable to apply 4.9.19: an unknown error has occurred: MultipleErrors
version 4.9.12 True True 20m Unable to apply 4.9.19: an unknown error has occurred: MultipleErrors
version 4.9.12 True True 21m Unable to apply 4.9.19: an unknown error has occurred: MultipleErrors
version 4.9.12 True True 21m Working towards 4.9.19: 590 of 738 done (79% complete)
version 4.9.12 True True 22m Working towards 4.9.19: 590 of 738 done (79% complete)
version 4.9.12 True True 22m Working towards 4.9.19: 590 of 738 done (79% complete)
version 4.9.12 True True 23m Working towards 4.9.19: 590 of 738 done (79% complete)
version 4.9.12 True True 23m Working towards 4.9.19: 590 of 738 done (79% complete)
version 4.9.12 True True 24m Working towards 4.9.19: 590 of 738 done (79% complete)
version 4.9.12 True True 24m Working towards 4.9.19: 601 of 738 done (81% complete)
version 4.9.12 True True 25m Working towards 4.9.19: 601 of 738 done (81% complete)
version 4.9.12 True True 25m Working towards 4.9.19: 619 of 738 done (83% complete)
version 4.9.12 True True 26m Unable to apply 4.9.19: the cluster operator machine-config has not yet successfully rolled out
version 4.9.12 True True 26m Unable to apply 4.9.19: the cluster operator machine-config has not yet successfully rolled out
version 4.9.12 True True 27m Unable to apply 4.9.19: the cluster operator machine-config has not yet successfully rolled out
version 4.9.12 True True 27m Unable to apply 4.9.19: the cluster operator machine-config has not yet successfully rolled out
version 4.9.12 True True 28m Unable to apply 4.9.19: the cluster operator machine-config has not yet successfully rolled out
version 4.9.12 True True 28m Unable to apply 4.9.19: the cluster operator machine-config has not yet successfully rolled out
version 4.9.12 True True 29m Unable to apply 4.9.19: the cluster operator machine-config has not yet successfully rolled out
version 4.9.12 True True 29m Unable to apply 4.9.19: the cluster operator machine-config has not yet successfully rolled out
version 4.9.12 True True 30m Working towards 4.9.19: 619 of 738 done (83% complete)
version 4.9.12 True True 30m Working towards 4.9.19: 619 of 738 done (83% complete)
version 4.9.12 True True 31m Working towards 4.9.19: 619 of 738 done (83% complete)
version 4.9.12 True True 31m Working towards 4.9.19: 619 of 738 done (83% complete)
version 4.9.12 True True 32m Working towards 4.9.19: 619 of 738 done (83% complete)
version 4.9.12 True True 32m Working towards 4.9.19: 619 of 738 done (83% complete)
The connection to the server api.cnfdc8.sno.e2e.bos.redhat.com:6443 was refused - did you specify the right host or port?

Unable to connect to the server: dial tcp 10.19.16.57:6443: i/o timeout

Unable to connect to the server: dial tcp 10.19.16.57:6443: i/o timeout

The connection to the server api.cnfdc8.sno.e2e.bos.redhat.com:6443 was refused - did you specify the right host or port?

The connection to the server api.cnfdc8.sno.e2e.bos.redhat.com:6443 was refused - did you specify the right host or port?

The connection to the server api.cnfdc8.sno.e2e.bos.redhat.com:6443 was refused - did you specify the right host or port?

The connection to the server api.cnfdc8.sno.e2e.bos.redhat.com:6443 was refused - did you specify the right host or port?

version 4.9.12 True True 40m Working towards 4.9.19: 619 of 738 done (83% complete)
version 4.9.12 True True 40m Working towards 4.9.19: 619 of 738 done (83% complete)
version 4.9.12 True True 41m Working towards 4.9.19: 619 of 738 done (83% complete)
version 4.9.12 True True 42m Working towards 4.9.19: 619 of 738 done (83% complete)
version 4.9.12 True True 42m Working towards 4.9.19: 619 of 738 done (83% complete)
version 4.9.12 True True 43m Working towards 4.9.19: 619 of 738 done (83% complete)
version 4.9.12 True True 43m Working towards 4.9.19: 619 of 738 done (83% complete)
version 4.9.12 True True 44m Working towards 4.9.19: 314 of 738 done (42% complete)
version 4.9.12 True True 44m Working towards 4.9.19: 619 of 738 done (83% complete)
Upgrade finished
Upgrade to version 4.9.19 started at Mon Feb 28 01:17:32 PM CET 2022 and finished at Mon Feb 28 02:02:28 PM CET 2022
```
