# 核心文件
1. Main.lua 
主入口
2. Setup.lua 
框架必备的启动逻辑
3. Config.lua
配置文件

# 目录结构
1. Core
存放核心文件
2. Debug
存放调试文件
3. Toolkit
存放工具包代码，每一个文件夹都代表着一个独立的可复用的工具；
4. Utils
存放通用函数或者扩展函数
5. Module
存放某一类业务模块的代码，使用MVC的形式存放文件，比如登录、活动、引导等等就是属于模块；
6. Game
存放战斗代码
7. UI
存放UI代码

# 模块介绍
1. 业务框架
整体使用门面模式(Facade)+MVC结构
Facade层：入口层，启动时会自动加载整个工程下的所有Facade，自动绑定对应的Ctrl和Proxy类，一般只是作为入口，不承担过多复杂逻辑；
Ctrl层：控制层，分为LogicCtrl与ViewCtrl，ViewCtrl直接操控界面，LogicCtrl只负责逻辑处理
Proxy层：数据层，处理业务数据和协议数据，底层使用DataWater监听数据变化；
View层：视图层，分为ViewUI和ComUI，ViewUI是容器，ComUI是组件，在UIDefine中配置后，结合ViewCtrl处理界面逻辑；

2. UI框架
3. 战斗框架
4. 资源加载与热更
5. 音频管理

# 其他
1. 导表工具
2. 搜索算法，四叉树，JPS