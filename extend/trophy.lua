----------------------------------------
-- Vita専用システム
----------------------------------------
-- トロフィータグ
function tags.trophy(e, p)		if game.ps then setTrophy(p["0"] or p.name) end	return 1 end
function tags.setTrophy(e, p)	if game.ps then setTrophy(p["0"] or p.name) end	return 1 end
function tags.checktrophy(e, p)	if game.ps then checktrophy(p) end				return 1 end
----------------------------------------
-- トロフィー開放
function setTrophy(name)
	if game.ps and not getTrial() then
		if not gscr.trophy then gscr.trophy = {} end
		local v  = csv.trophy[name]
		local no = v and v[1]
		if not no then
			error_message(name.."は不明なトロフィーです")
		elseif gscr.trophy[no] then
			message("通知", name, "は登録済みのトロフィーです")
			eqtag{"trophy", id=(no)}
		else
			message("通知", "Trophy:", name, "を開放しました")
			eqtag{"trophy", id=(no)}
			gscr.trophy[no] = true
		end
	end
end
----------------------------------------
-- トロフィーチェック
function checktrophy(p)
	if game.ps and not getTrial() then
		if not gscr.trophy then gscr.trophy = {} end
		local name = p["0"] or p.name
		local v    = csv.trophy[name]
		if gscr.trophy[name] then
			message("通知", name, "は登録済みです")
		elseif v then
			local nm = v[1]		-- 管理変数名
			local mx = v[2]		-- 最大数
			local tr = v[3]		-- トロフィー名
			local no = gscr.trophy[nm] or 0
			if no >= 0 then
				message("通知", "Trophy flag:", name, "を開放しました")
				gscr.trophy[name] = true
				no = no + 1
				if no == mx then
					setTrophy(tr)
					no = -1
				end
				gscr.trophy[nm] = no
			end
		end
	end
end
----------------------------------------
-- トロフィー状態
function tags.getTrophy(e, p)
	local nm = p["0"] or p.name
	if nm then
		e:tag{"trophy", id="-1"}
		e:tag{"var", name="t.result", ["system"]="get_trophy_status", id=(nm)}
		local n = tn(e:var("t.result"))
		if n == -2 then
			error_message("トロフィーの取得に失敗しました:"..nm)
		elseif n == -1 then
			message("通知", nm, "は登録中です")
		else
			checkTrophy()
		end
	end
	return 1
end
----------------------------------------
