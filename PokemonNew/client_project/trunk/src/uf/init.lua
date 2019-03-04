protobuf = require "uf.pbc"
uf_notifyLayer = TopLevelLayer:getInstance():getTopLevelNode()
uf_notifyLayer:retain();--原则上是常驻的 不加的话模拟器刷新关闭会出问题
uf_netManager = require("src.uf.net.NetManager").new()
uf_messageDispatcher = require("src.uf.net.MessageDispatcher").new()
uf_eventManager = require("src.uf.event.EventManager").new()
-- uf_dnsCache = require("src.uf.dns.DNSCache")
-- uf_gatewayCache = require("src.uf.dns.GatewayCache")

require("src.uf.utils.displayUtils")