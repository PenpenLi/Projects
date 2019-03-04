

----==========
----炼化台的静态常量
----==========
local RecycleConst = {}

---颜色高于等于紫色的装备分解的时候需要提醒。
RecycleConst.NEED_CONFIRM_EQUIP_COLOR = 5

---每次分解的最大数量
RecycleConst.MAX_RECYCLE_NUM = 5

---免疫属性的类型值，在显示表现上与其他属性不一样。
RecycleConst.ATTRIBUTE_IMMUNITY = 3

---可以被分解的武将类型
RecycleConst.RECYCLE_KNIGHT_TYPE = 2

return RecycleConst