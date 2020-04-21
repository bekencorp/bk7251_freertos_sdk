# bk7251_freertos_sdk



## 当前repository中submodule所在分支

| submodule | branch |
| --------- | ------ |
| beken378  | master |

> clone代码后，需执行如下命令：

```shell
cd beken378
git checkout master
```

> 如果不确定submodule所在分支，可用如下命令查找并手动确认

```shell
cd beken378
git branch -r --contains CommitID
```



## 代码管理策略 

随着项目的日益增多，决定使用`submodule+branch`的方式来管理
1. 每类项目单独创建一个`repository`
2. 同类项目用分支区分不同产品、不同代理商、不同客户
3. `beken378`使用`submodule`关联，`beken378`包含协议栈源码，相当于`fullcode`，发布时可使用脚本自动剔除协议栈等源码
4. 在项目稳定前，可直接使用`submodule`主分支，如果`submodule`有重大功能合入，可提前创建项目分支
5. 在提交代码时，不同目的的修改分开提交，便于向其它分支合入
6. 在提交代码后，如果需要将修改合入其它分支，使用`git cherry-pick commitid`
7. 在版本发布后，使用`git tag -a -m "notes" tag_name`创建标签，并用`git push --tags`提交





## Build with Makefile

- Install arm-gcc tool-chain and add path to system environment
- update `make.exe` in rt-thread env with `tool\make\make.exe` if you want to use parallel compiling with it
- update `beken378\app\config\sys_config.h` if needed
- make target [-j6]

```shell
make bk7231u -j8
make bk7251
make bk7231 -j6
make ip
make ble
make clean
```
