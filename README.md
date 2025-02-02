> 魔改自 [idxuanjun/bx_vimim_dict](https://github.com/idxuanjun/bx_vimim_dict)

使用说明
--------
* 自定义码表，路径`i1m/dict.txt`
* 中英文标点切换：插入模式下 CTRL-\
* 四码上屏，空格主选，分号次选，回车原英文字母

配置
--------
```bash
inoremap<silent><expr> <C-L> i1m#Toggle()
```

码表格式参考
--------
```txt
xnhe 小鹤
```
