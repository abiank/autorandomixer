--if (gxdialog) then gxdialog:close() end

trace = function(s)
  if (type(s) == 'table') then
    rprint(s)
  for t,tt in pairs(s)
    do
    oprint(s[t])
    end
  else
    oprint(s)
  end
end

vb = renoise.ViewBuilder()

obj = vb:column {id="gxc"}
obj:add_child(
    vb:row {vb:text{text="GLOBALS ==>",width=80},
    vb:minislider {id="gxprob",min=0,max=100,value=10,width=40  },
    vb:checkbox{id="gxcbt",tooltip="BOH"},
    vb:valuebox {id="gxvbt",min=0,max=10,value=5  },
    vb:text {text="mute%" ,width=40},
    vb:text {text="mute%" ,width=40},
    vb:text {text="mute%" ,width=40},
    vb:switch {id="gxsolo", items = {"A", "B", "C","o"},width=80},
    vb:textfield {id="nCorrente",text="mute%" },
    vb:switch {id="gxoperate", items = {"OFF","ON"},width=80},
      })


crea = function() 

for t,tt in pairs(renoise.song().tracks) 
do
local ct = vb:row {vb:text{text=renoise.song().tracks[t].name,width=80},
vb:minislider {id="probt"..t,min=0,max=1.40,width=40,value=renoise.song().tracks[t].devices[1].parameters[2].value,notifier=function (v) renoise.song().tracks[t].devices[1].parameters[2].value=v end  },
vb:checkbox{id="cbt"..t,tooltip=renoise.song().tracks[t].name,value=true},
vb:valuebox {id="vbt"..t,min=0,max=141,value=renoise.song().tracks[t].devices[1].parameters[2].value*100,notifier=function (v) renoise.song().tracks[t].devices[1].parameters[2].value=v/100 end   },
vb:minislider {id="prob1mut"..t,min=0,max=1.40,width=40,value=renoise.song().tracks[t].devices[1].parameters[2].value,notifier=function (v) renoise.song().tracks[t].devices[1].parameters[2].value=v end  },
vb:minislider {id="prob2mut"..t,min=0,max=1.40,width=40,value=renoise.song().tracks[t].devices[1].parameters[2].value,notifier=function (v) renoise.song().tracks[t].devices[1].parameters[2].value=v end  },
vb:minislider {id="prob3mut"..t,min=0,max=1.40,width=40,value=renoise.song().tracks[t].devices[1].parameters[2].value,notifier=function (v) renoise.song().tracks[t].devices[1].parameters[2].value=v end  },


vb:switch {id="vbs"..t, items = {"A", "B", "C"}, width=60}
  }
for k,v in pairs(renoise.song().tracks[t].devices) 
do 
  ct:add_child(vb:checkbox {value=renoise.song().tracks[t].devices[k].is_active,notifier=function (v)
       print(v) 
       trace(renoise.song().tracks[t].devices[k].parameters) 
       print("-----------------------------------")
       trace(renoise.song().tracks[t].devices[k])
       renoise.song().tracks[t].devices[k].is_active=v
       for p,pp in pairs(renoise.song().tracks[t].devices[k].parameters)
          do
           if (p ~= nil) then  print(renoise.song().tracks[t].devices[k].parameters[p].name) end
          end
       
     end,tooltip=renoise.song().tracks[t].devices[k].name,id="cbt"..t.."d"..k  })
end
obj:add_child(ct)
end
end

crea()
oprint(obj)

obj:add_child(
    vb:row {
    
    vb:button {
      text = "Save status!",
      tooltip = "Save status",
      height = renoise.ViewBuilder.DEFAULT_DIALOG_BUTTON_HEIGHT,
    width = vb.views["gxc"].width/2,
      notifier = function()
        print("magari")
      end
    },
    vb:button {
      text = "Exec",
      tooltip = "Save status",
      height = renoise.ViewBuilder.DEFAULT_DIALOG_BUTTON_HEIGHT,
    width = vb.views["gxc"].width/2,
      notifier = function()
        print("magari")
      end
    }    
      })

obj:add_child(
    vb:row {
     vb:multiline_textfield {  id = 'tedi',      text = "edit\n.",
      tooltip = "editor",
      height = 46  ,
     width = vb.views["gxc"].width },  

      })

  
gxdialog = renoise.app():show_custom_dialog  (
    "Auto Generator X",
   obj
  )
  
----------------------------------------------  
-------------------------------------------------------------------------------  
--rprint(vb.views)
-------------------------------------------------------------------------------
----------------------------------------------

  
  
  bDoLoop=true
  bDoMapping=true
  nLoopMode=1
  bDoSync=true
  nSyncLines=12
  bDoAutoseek=true
  nSlices=12
  
  
  DEFAULT_CONTROL_SPACING = renoise.ViewBuilder.DEFAULT_CONTROL_SPACING

  DEFAULT_DIALOG_MARGIN = renoise.ViewBuilder.DEFAULT_DIALOG_MARGIN
  DEFAULT_DIALOG_SPACING = renoise.ViewBuilder.DEFAULT_DIALOG_SPACING
  DEFAULT_DIALOG_BUTTON_HEIGHT = renoise.ViewBuilder.DEFAULT_DIALOG_BUTTON_HEIGHT
  
  TEXT_WIDTH = 80
  


s =""
bDisp=false
prob=0.3

mostra = function()
local sDisp="" 
for t,tt in pairs(renoise.song().tracks) 
  do
    for k,v in pairs(renoise.song().tracks[t].devices) 
    do 
      sDisp=sDisp .. ("--" .. t .. " : " .. k .. " : " .. renoise.song().tracks[t].devices[k].name) .. "\n"
      
      s =""
      for p,pp in pairs(renoise.song().tracks[t].devices[k].parameters)
      do 
      sDisp=sDisp .. ("  renoise.song().tracks["..t.."].devices["..k.."].parameters["..p.."].value="..renoise.song().tracks[t].devices[k].parameters[p].value.." --".. p .. " : "..renoise.song().tracks[t].devices[k].parameters[p].name.." ."  ) .. "\n"
    end
  end
  if bDisp then print (sDisp) end
  vb.views["tedi"]:clear()
  vb.views["tedi"].text=sDisp
  
end
end

corrente = 0  

cambia = function()
  if ( vb.views.gxoperate.value  == 1 ) then
    corrente=corrente+1
    print("cambiato")
    vb.views["nCorrente"].text=tostring(corrente)
     if bDisp then print("corrente:" .. corrente) end

     renoise.song().tracks[3].devices[1].parameters[2].value=math.abs(math.sin(corrente*2))
     renoise.song().tracks[2].devices[1].parameters[2].value=math.abs(math.cos(corrente*5))
     renoise.song().tracks[1].devices[1].parameters[2].value=math.abs(math.cos(corrente*2))
     renoise.song().tracks[4].devices[1].parameters[2].value=math.abs(math.sin(corrente*5))
     renoise.song().tracks[6].devices[1].parameters[2].value=math.abs(math.sin(corrente*2))
     renoise.song().tracks[4].devices[1].parameters[2].value=math.abs(math.sin(corrente*5))

     
     renoise.song().tracks[1].devices[1].parameters[1].value=math.abs(math.sin(corrente/7))
     renoise.song().tracks[2].devices[1].parameters[1].value=math.abs(math.sin(corrente/22))
     renoise.song().tracks[3].devices[1].parameters[1].value=math.abs(math.cos(corrente/19))


    prob = 0.20
    if (math.random()<prob) then renoise.song().tracks[1].devices[1].parameters[2].value=0 end
    if (math.random()<prob) then renoise.song().tracks[2].devices[1].parameters[2].value=0 end
    if (math.random()<prob) then renoise.song().tracks[3].devices[1].parameters[2].value=0 end
    if (math.random()<prob) then renoise.song().tracks[4].devices[1].parameters[2].value=0 end
    if (math.random()<prob) then renoise.song().tracks[6].devices[1].parameters[2].value=0 end
  end 
end  
  


renoise.song().selected_pattern_index_observable:add_notifier(function()
  if bDisp then print("selected_pattern_index:"..renoise.song().selected_pattern_index) end
end)

renoise.song().selected_sequence_index_observable:add_notifier(function()
   if bDisp then print("selected_sequence_index:"..renoise.song().selected_sequence_index) end
  mostra()
  cambia()
end)

for t,tt in pairs(renoise.song().tracks) 
do
for k,v in pairs(renoise.song().tracks[t].devices) 
do 
print(t .. " : " .. k .. " : " .. renoise.song().tracks[t].devices[k].name)
s =""
for p,pp in pairs(renoise.song().tracks[t].devices[k].parameters)
do 
s = s .. p .. ":"..renoise.song().tracks[t].devices[k].parameters[p].name..":".. renoise.song().tracks[t].devices[k].parameters[p].value .. " "
end
print(s)
end
print ("")
end



oprint (renoise.song().tracks[1])
rprint(vb.views)

