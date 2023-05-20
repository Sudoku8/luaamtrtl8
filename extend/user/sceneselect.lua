-- シーンセレクト
----------------------------------------
-- 保存
function user_sceneselect(flag)
	local t  = { title=(scr.adv.title), ip=(scr.ip), sen_flag=(get_eval("f.sen_flag")) }
--	if flag then t.select = log.stack[#log.stack] end	-- 選択肢
	if flag then t.select = #log.stack end	-- 選択肢
	t.log = log.stack						-- log

	-- 保存
	local z = (scr.vari.sceneselect or 0) + 1
	local s = pluto.persist({}, t)
	tag{"var", name=("sceneselect."..z), data=(s)}
	scr.vari.sceneselect = z
--[[
	local z = scr.vari.sceneselect or {}
	local s = pluto.persist({}, t)
	table.insert(z, s)
	scr.vari.sceneselect = z
]]
	if not flag then flg.eval = true end
end
----------------------------------------
function user_logclick(e, p)
	local v  = getBtnInfo(p.bt or p.btn)
	local nm = v.p1
	local md = flg.blog.scenemode
	local sw = {
		-- 機能入れ替え
		chjump = function()
			flg.blog.cache = nil

			if md then	flg.blog.scenemode = nil	user_stackblog()
			else		flg.blog.scenemode = true	user_stackscene() end
		end,

		-- jump
		exjump = function()
			log_btnjump(e, p)
		end,
	}
	if sw[nm] then sw[nm]() end
end
----------------------------------------
-- blog読み直し
function user_stackblog()
	blog_init2()
	flip()
end
----------------------------------------
-- scene stack
function user_stackscene()
	backlog_mode(1, true)	-- テキスト消去

	-- cache
	flg.blog.cache= {}
--	local z  = scr.vari.sceneselect or {}
	local ln = get_language(true)	-- 多言語 / メイン
	local sl = get_langsystem("select")
--	local mx = #z
	local mx = scr.vari.sceneselect or 1
	for i=1, mx do
		local t  = { text={}, sub={}, voice={}, face={} }
--		local v  = pluto.unpersist({}, z[i])
		local v  = pluto.unpersist({}, e:var("sceneselect."..i))

		-- text
		local tx = v.title[ln] or v.title.text or ""
		t.text = {{ tx }}

		-- 選択肢
		if v.select then t.name = sl end

		flg.blog.cache[i] = t
	end

	-- ダミー作成
	local pgmx = init.backlog_page
	local mx2  = mx < pgmx and mx or pgmx
	sys.blog = { buff = 100 }
	flg.blog.page = 0
	flg.blog.max  = mx
	flg.blog.pgmx = mx2
--	flg.blog.file = file
	flg.blog.slider = nil

	-- uiの初期化
	csvbtn3("blog", "500", lang.ui_backlog)
--	view_backlog()			-- 最新データを読み込み

	if mx <= pgmx then
		-- slider
		tag{"lyprop", id="500.z.sl", visible="0"}

		-- 未使用ボタン
		for i=mx+1, pgmx do
			tag{"lyprop", id=("500.z.bt."..i), visible="0"}
			tag{"lyprop", id=("500.z.bx."..i), visible="0"}
		end
	else
		flg.blog.page   = mx - pgmx
		flg.blog.slider = true
	end

	-- mobile
	if game.sp then
		tag{"lyprop", id=(getBtnID("bt_scene")), visible="0"}
	end

	-- logo / help
	local v = getBtnInfo("logo") tag{"lyprop", id=(v.idx..".0"), clip=(v.clip_a)}
	if game.cs then local v = getBtnInfo("help") tag{"lyprop", id=(v.idx..".0"), clip=(v.clip_a)} end
	view_backlog()			-- 最新データを読み込み
	flip()
end
----------------------------------------
-- scene select
function user_logjump(no)
--	local z = scr.vari.sceneselect or {}
--	local p = z[no]
--	if not p then
	local z = scr.vari.sceneselect or 1
	local p = e:var("sceneselect."..no)
	if p == "0" then
		message("警告", no, "は不明な飛び先です")
		return
	end

	-- 巻き戻し
--	for i=#z, no, -1 do table.remove(z, i) end

	-- リセット
	sv.delpoint()		-- セーブ情報を念のため初期化しておく
	select_reset()
	adv_reset()

	-- 変数復帰
	local v  = pluto.unpersist({}, p)
	scr.vari = {}
--	scr.vari.sceneselect = z
	scr.vari.sceneselect = no - 1
	scr.vari.sen_flag = tn(v.sen_flag)
	log.stack = v.log

	-- 暗転
	local time = init.ui_fade
	allsound_stop{ mode="system", time=(time) }
	blog_reset()
	reset_bg()

	estag("init")
	estag{"uitrans", time}
	if v.select then
		estag{"user_logjumpselect", v}
	else
		estag{"user_logjumpfile", v}
	end
	estag()
end
----------------------------------------
function user_logjumpfile(p)
	ResetStack()	-- スタックリセット
--	readScriptStart(p.ip.file)

	-- reset
	scr.uifunc = nil
	adv_flagreset()
	adv_reset()

	-- 呼び出し
	readScript(p.ip.file)
--	reset_backlog()
	allkeyon()
	checkAread()		-- ファイル先頭の既読処理
	init_adv_btn()		-- ボタン設置
	autocache(true)		-- 自動キャッシュ
	e:tag{"jump", file="system/script.asb", label="main"}
end
----------------------------------------
function user_logjumpselect(p)
	ResetStack()	-- スタックリセット
	local z = p.log[p.select]
	log.stack = p.log
	quickjump(#log.stack, "ui")
end
----------------------------------------
