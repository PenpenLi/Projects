<GameFile>
  <PropertyGroup Name="WorldBossMainLayer" Type="Layer" ID="b47f0a5f-5ca5-4cb8-8fab-43e019808c76" Version="3.10.0.0" />
  <Content ctype="GameProjectContent">
    <Content>
      <Animation Duration="0" Speed="1.0000" />
      <ObjectData Name="Layer" Tag="99" ctype="GameLayerObjectData">
        <Size X="640.0000" Y="853.0000" />
        <Children>
          <AbstractNodeData Name="Panel_container" ActionTag="1991181917" Tag="163" IconVisible="False" StretchHeightEnable="True" ClipAble="False" BackColorAlpha="102" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
            <Size X="640.0000" Y="853.0000" />
            <Children>
              <AbstractNodeData Name="Image_bg" ActionTag="1411635597" Tag="81" IconVisible="False" PositionPercentXEnabled="True" VerticalEdge="BothEdge" BottomMargin="-287.0000" LeftEage="211" RightEage="211" TopEage="376" BottomEage="376" Scale9OriginX="211" Scale9OriginY="376" Scale9Width="218" Scale9Height="388" ctype="ImageViewObjectData">
                <Size X="640.0000" Y="1140.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="1.0000" />
                <Position X="320.0000" Y="853.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5000" Y="1.0000" />
                <PreSize X="1.0000" Y="1.3365" />
                <FileData Type="Normal" Path="newui/background/bg_worldboss.jpg" Plist="" />
              </AbstractNodeData>
              <AbstractNodeData Name="Panel_boss_all" ActionTag="1578222726" Tag="576" IconVisible="False" PositionPercentXEnabled="True" PercentWidthEnable="True" PercentHeightEnable="True" PercentWidthEnabled="True" PercentHeightEnabled="True" VerticalEdge="TopEdge" ClipAble="False" BackColorAlpha="102" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
                <Size X="640.0000" Y="853.0000" />
                <Children>
                  <AbstractNodeData Name="Panel_bossImage" ActionTag="426922981" Tag="591" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="309.4840" RightMargin="1.5160" TopMargin="21.7498" BottomMargin="398.2502" ClipAble="False" BackColorAlpha="102" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
                    <Size X="329.0000" Y="433.0000" />
                    <Children>
                      <AbstractNodeData Name="Node_boss_spine" ActionTag="1186900458" Tag="352" IconVisible="True" LeftMargin="63.3345" RightMargin="265.6655" TopMargin="244.1113" BottomMargin="188.8887" ctype="SingleNodeObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <AnchorPoint />
                        <Position X="63.3345" Y="188.8887" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.1925" Y="0.4362" />
                        <PreSize X="0.0000" Y="0.0000" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="473.9840" Y="614.7502" />
                    <Scale ScaleX="0.9000" ScaleY="0.9000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.7406" Y="0.7207" />
                    <PreSize X="0.5141" Y="0.5076" />
                    <SingleColor A="255" R="150" G="200" B="255" />
                    <FirstColor A="255" R="150" G="200" B="255" />
                    <EndColor A="255" R="255" G="255" B="255" />
                    <ColorVector ScaleY="1.0000" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Image_boss_dead" ActionTag="-317307648" Tag="171" IconVisible="False" LeftMargin="265.5863" RightMargin="285.4137" TopMargin="385.9133" BottomMargin="377.0867" LeftEage="29" RightEage="29" TopEage="29" BottomEage="29" Scale9OriginX="29" Scale9OriginY="29" Scale9Width="31" Scale9Height="32" ctype="ImageViewObjectData">
                    <Size X="89.0000" Y="90.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="310.0863" Y="422.0867" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.4845" Y="0.4948" />
                    <PreSize X="0.1391" Y="0.1055" />
                    <FileData Type="Normal" Path="newui/common/text/text_worldboss01.png" Plist="" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Image_noBoss" ActionTag="235568291" VisibleForFrame="False" Tag="75" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="142.7000" RightMargin="168.3000" TopMargin="233.5000" BottomMargin="186.5000" Scale9Width="46" Scale9Height="46" ctype="ImageViewObjectData">
                    <Size X="329.0000" Y="433.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="307.2000" Y="403.0000" />
                    <Scale ScaleX="0.8000" ScaleY="0.8000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.4800" Y="0.4725" />
                    <PreSize X="0.5141" Y="0.5076" />
                    <FileData Type="Default" Path="Default/ImageFile.png" Plist="" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Image_mark" ActionTag="-412636143" VisibleForFrame="False" Tag="592" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="247.0000" RightMargin="247.0000" TopMargin="340.1300" BottomMargin="415.8700" Scale9Width="76" Scale9Height="48" ctype="ImageViewObjectData">
                    <Size X="146.0000" Y="97.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="320.0000" Y="464.3700" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.5000" Y="0.5444" />
                    <PreSize X="0.2281" Y="0.1137" />
                    <FileData Type="Normal" Path="newui/text/signet/w_img1_signet14.png" Plist="" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Panel_noBoss_top" ActionTag="1779177567" VisibleForFrame="False" Tag="1011" IconVisible="False" PositionPercentXEnabled="True" VerticalEdge="TopEdge" TopMargin="222.0000" BottomMargin="521.0000" ClipAble="False" BackColorAlpha="102" ColorAngle="90.0000" LeftEage="50" RightEage="50" TopEage="50" BottomEage="50" Scale9OriginX="-50" Scale9OriginY="-50" Scale9Width="100" Scale9Height="100" ctype="PanelObjectData">
                    <Size X="640.0000" Y="110.0000" />
                    <Children>
                      <AbstractNodeData Name="Text_noBossName" ActionTag="51446497" Tag="571" IconVisible="False" PositionPercentXEnabled="True" VerticalEdge="TopEdge" LeftMargin="238.0000" RightMargin="238.0000" TopMargin="1.5063" BottomMargin="72.4937" FontSize="30" LabelText="未知的BOSS" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="164.0000" Y="36.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="320.0000" Y="90.4937" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.5000" Y="0.8227" />
                        <PreSize X="0.2562" Y="0.3273" />
                        <FontResource Type="Normal" Path="fonts/font_wryh_b.ttf" Plist="" />
                        <OutlineColor A="255" R="0" G="0" B="0" />
                        <ShadowColor A="255" R="0" G="0" B="0" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="0.5000" ScaleY="1.0000" />
                    <Position X="320.0000" Y="631.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.5000" Y="0.7397" />
                    <PreSize X="1.0000" Y="0.1290" />
                    <SingleColor A="255" R="150" G="200" B="255" />
                    <FirstColor A="255" R="150" G="200" B="255" />
                    <EndColor A="255" R="255" G="255" B="255" />
                    <ColorVector ScaleY="1.0000" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Panel_boss_top" ActionTag="1378044931" Tag="1072" IconVisible="False" PositionPercentXEnabled="True" TopMargin="222.0000" BottomMargin="521.0000" ClipAble="False" BackColorAlpha="102" ColorAngle="90.0000" LeftEage="50" RightEage="50" TopEage="50" BottomEage="50" Scale9OriginX="-50" Scale9OriginY="-50" Scale9Width="100" Scale9Height="100" ctype="PanelObjectData">
                    <Size X="640.0000" Y="110.0000" />
                    <Children>
                      <AbstractNodeData Name="Text_bossName" ActionTag="767902632" Tag="578" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="233.9120" RightMargin="313.0880" TopMargin="-50.7484" BottomMargin="130.7484" FontSize="22" LabelText="混世魔王" OutlineSize="2" OutlineEnabled="True" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="93.0000" Y="30.0000" />
                        <AnchorPoint ScaleX="1.0000" ScaleY="0.5000" />
                        <Position X="326.9120" Y="145.7484" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="0" G="217" B="243" />
                        <PrePosition X="0.5108" Y="1.3250" />
                        <PreSize X="0.1453" Y="0.2727" />
                        <FontResource Type="Normal" Path="fonts/font_wryh_b.ttf" Plist="" />
                        <OutlineColor A="255" R="6" G="42" B="109" />
                        <ShadowColor A="255" R="0" G="0" B="0" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_bossHPInfo" ActionTag="44901676" VisibleForFrame="False" Tag="640" IconVisible="False" PositionPercentYEnabled="True" LeftMargin="97.6596" RightMargin="491.3404" TopMargin="376.1430" BottomMargin="-295.1430" FontSize="24" LabelText="血量" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="51.0000" Y="29.0000" />
                        <AnchorPoint ScaleX="1.0000" ScaleY="0.5000" />
                        <Position X="148.6596" Y="-280.6430" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.2323" Y="-2.5513" />
                        <PreSize X="0.0797" Y="0.2636" />
                        <FontResource Type="Normal" Path="fonts/font_wryh_b.ttf" Plist="" />
                        <OutlineColor A="255" R="0" G="0" B="0" />
                        <ShadowColor A="255" R="0" G="0" B="0" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_bossLevel" ActionTag="1375846242" Tag="272" IconVisible="False" LeftMargin="345.0300" RightMargin="256.9700" TopMargin="-49.0508" BottomMargin="129.0508" FontSize="22" LabelText="lv.5" OutlineSize="2" OutlineEnabled="True" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="38.0000" Y="30.0000" />
                        <AnchorPoint ScaleY="0.5316" />
                        <Position X="345.0300" Y="144.9988" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="250" G="240" B="73" />
                        <PrePosition X="0.5391" Y="1.3182" />
                        <PreSize X="0.0594" Y="0.2727" />
                        <FontResource Type="Normal" Path="fonts/font_wryh_b.ttf" Plist="" />
                        <OutlineColor A="255" R="100" G="11" B="9" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="0.5000" ScaleY="1.0000" />
                    <Position X="320.0000" Y="631.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.5000" Y="0.7397" />
                    <PreSize X="1.0000" Y="0.1290" />
                    <SingleColor A="255" R="150" G="200" B="255" />
                    <FirstColor A="255" R="150" G="200" B="255" />
                    <EndColor A="255" R="255" G="255" B="255" />
                    <ColorVector ScaleY="1.0000" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleX="0.5000" ScaleY="1.0000" />
                <Position X="320.0000" Y="853.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5000" Y="1.0000" />
                <PreSize X="1.0000" Y="1.0000" />
                <SingleColor A="255" R="150" G="200" B="255" />
                <FirstColor A="255" R="150" G="200" B="255" />
                <EndColor A="255" R="255" G="255" B="255" />
                <ColorVector ScaleY="1.0000" />
              </AbstractNodeData>
              <AbstractNodeData Name="Panel_top" ActionTag="-836931036" Tag="181" IconVisible="False" VerticalEdge="TopEdge" TopMargin="35.0000" BottomMargin="708.0000" ClipAble="False" BackColorAlpha="102" ColorAngle="90.0000" LeftEage="50" RightEage="50" TopEage="50" BottomEage="50" Scale9OriginX="-50" Scale9OriginY="-50" Scale9Width="100" Scale9Height="100" ctype="PanelObjectData">
                <Size X="640.0000" Y="110.0000" />
                <Children>
                  <AbstractNodeData Name="Panel_info" ActionTag="1898931266" VisibleForFrame="False" Tag="166" IconVisible="False" LeftMargin="6.0000" RightMargin="354.0000" TopMargin="70.0000" BottomMargin="-70.0000" ClipAble="False" BackColorAlpha="102" ColorAngle="90.0000" Scale9Enable="True" LeftEage="10" RightEage="100" TopEage="5" BottomEage="5" Scale9OriginX="-100" Scale9OriginY="-5" Scale9Width="110" Scale9Height="10" ctype="PanelObjectData">
                    <Size X="280.0000" Y="110.0000" />
                    <Children>
                      <AbstractNodeData Name="Image_exploit_bg" ActionTag="-1359818953" Tag="87" IconVisible="False" PositionPercentYEnabled="True" LeftMargin="-255.0000" RightMargin="285.0000" TopMargin="5.5000" BottomMargin="38.5000" FlipX="True" Scale9Enable="True" TopEage="20" BottomEage="20" Scale9OriginY="20" Scale9Width="528" Scale9Height="36" ctype="ImageViewObjectData">
                        <Size X="250.0000" Y="66.0000" />
                        <AnchorPoint ScaleX="1.0000" ScaleY="0.5000" />
                        <Position X="-5.0000" Y="71.5000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="-0.0179" Y="0.6500" />
                        <PreSize X="0.8929" Y="0.6000" />
                        <FileData Type="Normal" Path="newui/common/img_com_board_s01.png" Plist="" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_exploitTitle" ActionTag="-1311985987" Tag="167" IconVisible="False" PositionPercentYEnabled="True" LeftMargin="6.4662" RightMargin="187.5338" TopMargin="27.0000" BottomMargin="60.0000" FontSize="19" LabelText="累计伤害：" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="86.0000" Y="23.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="6.4662" Y="71.5000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="214" B="105" />
                        <PrePosition X="0.0231" Y="0.6500" />
                        <PreSize X="0.3071" Y="0.2091" />
                        <FontResource Type="Normal" Path="fonts/font_wryh_b.ttf" Plist="" />
                        <OutlineColor A="255" R="0" G="0" B="0" />
                        <ShadowColor A="255" R="0" G="0" B="0" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_exploit" ActionTag="1198221628" Tag="168" IconVisible="False" PositionPercentYEnabled="True" LeftMargin="110.0000" RightMargin="156.0000" TopMargin="27.0000" BottomMargin="60.0000" FontSize="19" LabelText="0" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="14.0000" Y="23.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="110.0000" Y="71.5000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="238" G="225" B="207" />
                        <PrePosition X="0.3929" Y="0.6500" />
                        <PreSize X="0.0500" Y="0.2091" />
                        <FontResource Type="Normal" Path="fonts/font_wryh_b.ttf" Plist="" />
                        <OutlineColor A="255" R="0" G="0" B="0" />
                        <ShadowColor A="255" R="0" G="0" B="0" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint />
                    <Position X="6.0000" Y="-70.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.0094" Y="-0.6364" />
                    <PreSize X="0.4375" Y="1.0000" />
                    <SingleColor A="255" R="150" G="200" B="255" />
                    <FirstColor A="255" R="150" G="200" B="255" />
                    <EndColor A="255" R="255" G="255" B="255" />
                    <ColorVector ScaleY="1.0000" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Panel_menus" ActionTag="-234508768" Tag="1187" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="390.0000" TopMargin="65.0040" BottomMargin="-65.0040" ClipAble="False" BackColorAlpha="102" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
                    <Size X="250.0000" Y="110.0000" />
                    <Children>
                      <AbstractNodeData Name="Button_help" ActionTag="-1142925922" Tag="243" IconVisible="False" LeftMargin="48.7734" RightMargin="159.2266" TopMargin="-32.8938" BottomMargin="100.8938" TouchEnable="True" FontSize="32" LeftEage="11" RightEage="11" TopEage="11" BottomEage="11" Scale9OriginX="11" Scale9OriginY="11" Scale9Width="20" Scale9Height="20" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                        <Size X="42.0000" Y="42.0000" />
                        <Children>
                          <AbstractNodeData Name="Text_help_btn" ActionTag="1592704655" VisibleForFrame="False" Tag="244" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="-5.0000" RightMargin="-5.0000" TopMargin="21.0000" BottomMargin="-5.0000" FontSize="22" LabelText="帮 助" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                            <Size X="52.0000" Y="26.0000" />
                            <AnchorPoint ScaleX="0.5000" />
                            <Position X="21.0000" Y="-5.0000" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition X="0.5000" Y="-0.1190" />
                            <PreSize X="1.2381" Y="0.6190" />
                            <FontResource Type="Normal" Path="fonts/font_wryh_b.ttf" Plist="" />
                            <OutlineColor A="255" R="0" G="0" B="0" />
                            <ShadowColor A="255" R="0" G="0" B="0" />
                          </AbstractNodeData>
                        </Children>
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="69.7734" Y="121.8938" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.2791" Y="1.1081" />
                        <PreSize X="0.1680" Y="0.3818" />
                        <TextColor A="255" R="255" G="255" B="255" />
                        <NormalFileData Type="Normal" Path="newui/common/btn/btn_help01.png" Plist="" />
                        <OutlineColor A="255" R="0" G="0" B="0" />
                        <ShadowColor A="255" R="0" G="0" B="0" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="1.0000" />
                    <Position X="640.0000" Y="-65.0040" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="1.0000" Y="-0.5909" />
                    <PreSize X="0.3906" Y="1.0000" />
                    <SingleColor A="255" R="150" G="200" B="255" />
                    <FirstColor A="255" R="150" G="200" B="255" />
                    <EndColor A="255" R="255" G="255" B="255" />
                    <ColorVector ScaleY="1.0000" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="ProjectNode_feat" ActionTag="1732109652" VisibleForFrame="False" Tag="83" IconVisible="True" PositionPercentXEnabled="True" LeftMargin="640.0000" TopMargin="195.0000" BottomMargin="-85.0000" StretchWidthEnable="False" StretchHeightEnable="False" InnerActionSpeed="1.0000" CustomSizeEnabled="False" ctype="ProjectNodeObjectData">
                    <Size X="0.0000" Y="0.0000" />
                    <AnchorPoint />
                    <Position X="640.0000" Y="-85.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="1.0000" Y="-0.7727" />
                    <PreSize X="0.0000" Y="0.0000" />
                    <FileData Type="Normal" Path="csb/common/CommonSysResNode.csd" Plist="" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Image_title" ActionTag="1491672558" VisibleForFrame="False" Tag="981" IconVisible="False" PositionPercentXEnabled="True" VerticalEdge="TopEdge" RightMargin="388.0000" TopMargin="15.0000" BottomMargin="27.0000" Scale9Width="252" Scale9Height="68" ctype="ImageViewObjectData">
                    <Size X="252.0000" Y="68.0000" />
                    <Children>
                      <AbstractNodeData Name="Image_txt" ActionTag="-1701327389" Tag="982" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="16.0000" RightMargin="16.0000" TopMargin="1.1600" BottomMargin="18.8400" Scale9Width="220" Scale9Height="48" ctype="ImageViewObjectData">
                        <Size X="220.0000" Y="48.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="126.0000" Y="42.8400" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.5000" Y="0.6300" />
                        <PreSize X="0.8730" Y="0.7059" />
                        <FileData Type="Normal" Path="newui/text/system/txt_sys_title_boss01.png" Plist="" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleY="1.0000" />
                    <Position Y="95.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition Y="0.8636" />
                    <PreSize X="0.3938" Y="0.6182" />
                    <FileData Type="Normal" Path="newui/common/img_com_title_sys01.png" Plist="" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="ProjectNode_back" ActionTag="-22199724" Tag="983" IconVisible="True" PositionPercentXEnabled="True" VerticalEdge="TopEdge" LeftMargin="563.7120" RightMargin="76.2880" TopMargin="53.5771" BottomMargin="56.4229" StretchWidthEnable="False" StretchHeightEnable="False" InnerActionSpeed="1.0000" CustomSizeEnabled="False" ctype="ProjectNodeObjectData">
                    <Size X="0.0000" Y="0.0000" />
                    <AnchorPoint />
                    <Position X="563.7120" Y="56.4229" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.8808" Y="0.5129" />
                    <PreSize X="0.0000" Y="0.0000" />
                    <FileData Type="Normal" Path="csb/common/CommonBackNode.csd" Plist="" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleY="1.0000" />
                <Position Y="818.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition Y="0.9590" />
                <PreSize X="1.0000" Y="0.1290" />
                <SingleColor A="255" R="150" G="200" B="255" />
                <FirstColor A="255" R="150" G="200" B="255" />
                <EndColor A="255" R="255" G="255" B="255" />
                <ColorVector ScaleY="1.0000" />
              </AbstractNodeData>
              <AbstractNodeData Name="Panel_boss_middle" ActionTag="-329978052" Tag="249" IconVisible="False" PositionPercentXEnabled="True" PercentWidthEnable="True" PercentWidthEnabled="True" VerticalEdge="TopEdge" LeftMargin="1.5360" RightMargin="-1.5360" TopMargin="239.2665" BottomMargin="160.7335" ClipAble="False" BackColorAlpha="102" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
                <Size X="640.0000" Y="453.0000" />
                <Children>
                  <AbstractNodeData Name="Image_8" ActionTag="-493455154" VisibleForFrame="False" Tag="418" IconVisible="False" VerticalEdge="TopEdge" LeftMargin="27.0270" RightMargin="425.9730" TopMargin="-78.1139" BottomMargin="505.1139" LeftEage="57" RightEage="57" TopEage="8" BottomEage="8" Scale9OriginX="57" Scale9OriginY="8" Scale9Width="73" Scale9Height="10" ctype="ImageViewObjectData">
                    <Size X="187.0000" Y="26.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="120.5270" Y="518.1139" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.1883" Y="1.1437" />
                    <PreSize X="0.2922" Y="0.0574" />
                    <FileData Type="Normal" Path="newui/common/shade/img_shade_worldboss07.png" Plist="" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Text_4" ActionTag="-1375140975" VisibleForFrame="False" Tag="417" IconVisible="False" VerticalEdge="TopEdge" LeftMargin="83.5039" RightMargin="481.4961" TopMargin="-76.4364" BottomMargin="507.4364" FontSize="18" LabelText="伤害排行" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                    <Size X="75.0000" Y="22.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="121.0039" Y="518.4364" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="249" B="153" />
                    <PrePosition X="0.1891" Y="1.1445" />
                    <PreSize X="0.1172" Y="0.0486" />
                    <FontResource Type="Normal" Path="fonts/font_wryh_b.ttf" Plist="" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="ListView_Rank" Visible="False" ActionTag="-2043698900" VisibleForFrame="False" Tag="263" IconVisible="False" LeftMargin="-2.5159" RightMargin="422.5159" TopMargin="-32.6652" BottomMargin="285.6652" TouchEnable="True" ClipAble="False" BackColorAlpha="102" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" ScrollDirectionType="0" DirectionType="Vertical" ctype="ListViewObjectData">
                    <Size X="220.0000" Y="200.0000" />
                    <AnchorPoint ScaleX="1.0000" ScaleY="1.0000" />
                    <Position X="217.4841" Y="485.6652" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.3398" Y="1.0721" />
                    <PreSize X="0.3438" Y="0.4415" />
                    <SingleColor A="255" R="150" G="150" B="255" />
                    <FirstColor A="255" R="150" G="150" B="255" />
                    <EndColor A="255" R="255" G="255" B="255" />
                    <ColorVector ScaleY="1.0000" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Panel_rank" ActionTag="-344286400" Tag="815" IconVisible="False" VerticalEdge="TopEdge" LeftMargin="19.6431" RightMargin="420.3569" TopMargin="-51.6766" BottomMargin="304.6766" TouchEnable="True" ClipAble="False" BackColorAlpha="102" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
                    <Size X="200.0000" Y="200.0000" />
                    <Children>
                      <AbstractNodeData Name="Image_rank_bg" ActionTag="-749908661" Tag="816" IconVisible="False" LeftMargin="-21.6064" RightMargin="-28.3881" TopMargin="0.4306" BottomMargin="67.5694" TouchEnable="True" LeftEage="74" RightEage="74" TopEage="43" BottomEage="43" Scale9OriginX="74" Scale9OriginY="43" Scale9Width="117" Scale9Height="47" ctype="ImageViewObjectData">
                        <Size X="249.9945" Y="132.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="-21.6064" Y="133.5694" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="-0.1080" Y="0.6678" />
                        <PreSize X="1.2500" Y="0.6600" />
                        <FileData Type="Normal" Path="newui/common/big_bg/paihang.png" Plist="" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_84" ActionTag="149859333" VisibleForFrame="False" Tag="817" IconVisible="False" LeftMargin="-34.5061" RightMargin="-32.4939" TopMargin="94.2240" BottomMargin="75.7760" LeftEage="74" RightEage="74" TopEage="15" BottomEage="15" Scale9OriginX="74" Scale9OriginY="15" Scale9Width="119" Scale9Height="1" ctype="ImageViewObjectData">
                        <Size X="267.0000" Y="30.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="98.9939" Y="90.7760" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.4950" Y="0.4539" />
                        <PreSize X="1.3350" Y="0.1500" />
                        <FileData Type="Normal" Path="newui/common/shade/img_shade_worldboss05.png" Plist="" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_harm_value1" ActionTag="-1244676825" Tag="867" IconVisible="False" LeftMargin="154.1799" RightMargin="-8.1799" TopMargin="9.6336" BottomMargin="172.3664" FontSize="15" LabelText="4845万" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="54.0000" Y="18.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="154.1799" Y="181.3664" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="240" B="75" />
                        <PrePosition X="0.7709" Y="0.9068" />
                        <PreSize X="0.2700" Y="0.0900" />
                        <FontResource Type="Normal" Path="fonts/font_wryh_b.ttf" Plist="" />
                        <OutlineColor A="255" R="0" G="0" B="0" />
                        <ShadowColor A="255" R="0" G="0" B="0" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_user_name1" ActionTag="1860955426" Tag="868" IconVisible="False" LeftMargin="44.2000" RightMargin="62.8000" TopMargin="9.9700" BottomMargin="172.0300" FontSize="15" LabelText="浪太大听不见" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="93.0000" Y="18.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="44.2000" Y="181.0300" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="240" B="75" />
                        <PrePosition X="0.2210" Y="0.9051" />
                        <PreSize X="0.4650" Y="0.0900" />
                        <FontResource Type="Normal" Path="fonts/font_wryh_b.ttf" Plist="" />
                        <OutlineColor A="255" R="0" G="0" B="0" />
                        <ShadowColor A="255" R="0" G="0" B="0" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_harm_rank" ActionTag="60776209" VisibleForFrame="False" Tag="869" IconVisible="False" LeftMargin="6.8600" RightMargin="180.1400" TopMargin="11.6200" BottomMargin="170.3800" FontSize="15" LabelText="1." ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="13.0000" Y="18.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="6.8600" Y="179.3800" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="252" G="255" B="188" />
                        <PrePosition X="0.0343" Y="0.8969" />
                        <PreSize X="0.0650" Y="0.0900" />
                        <FontResource Type="Normal" Path="fonts/font_wryh_b.ttf" Plist="" />
                        <OutlineColor A="255" R="0" G="0" B="0" />
                        <ShadowColor A="255" R="0" G="0" B="0" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_harm_value2" ActionTag="1465438264" Tag="870" IconVisible="False" LeftMargin="154.1799" RightMargin="-8.1799" TopMargin="38.3788" BottomMargin="143.6212" FontSize="15" LabelText="4845万" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="54.0000" Y="18.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="154.1799" Y="152.6212" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="206" G="214" B="227" />
                        <PrePosition X="0.7709" Y="0.7631" />
                        <PreSize X="0.2700" Y="0.0900" />
                        <FontResource Type="Normal" Path="fonts/font_wryh_b.ttf" Plist="" />
                        <OutlineColor A="255" R="0" G="0" B="0" />
                        <ShadowColor A="255" R="0" G="0" B="0" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_user_name2" ActionTag="448541580" Tag="871" IconVisible="False" LeftMargin="44.2000" RightMargin="62.8000" TopMargin="38.7100" BottomMargin="143.2900" FontSize="15" LabelText="浪太大听不见" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="93.0000" Y="18.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="44.2000" Y="152.2900" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="206" G="214" B="227" />
                        <PrePosition X="0.2210" Y="0.7614" />
                        <PreSize X="0.4650" Y="0.0900" />
                        <FontResource Type="Normal" Path="fonts/font_wryh_b.ttf" Plist="" />
                        <OutlineColor A="255" R="0" G="0" B="0" />
                        <ShadowColor A="255" R="0" G="0" B="0" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_harm_rank_0" ActionTag="-1703669951" VisibleForFrame="False" Tag="872" IconVisible="False" LeftMargin="6.8600" RightMargin="177.1400" TopMargin="39.0715" BottomMargin="142.9285" FontSize="15" LabelText="2." ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="16.0000" Y="18.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="6.8600" Y="151.9285" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="252" G="255" B="188" />
                        <PrePosition X="0.0343" Y="0.7596" />
                        <PreSize X="0.0800" Y="0.0900" />
                        <FontResource Type="Normal" Path="fonts/font_wryh_b.ttf" Plist="" />
                        <OutlineColor A="255" R="0" G="0" B="0" />
                        <ShadowColor A="255" R="0" G="0" B="0" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_harm_value3" ActionTag="-323335486" Tag="873" IconVisible="False" LeftMargin="154.1799" RightMargin="-8.1799" TopMargin="65.9614" BottomMargin="116.0386" FontSize="15" LabelText="4845万" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="54.0000" Y="18.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="154.1799" Y="125.0386" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="216" G="117" B="67" />
                        <PrePosition X="0.7709" Y="0.6252" />
                        <PreSize X="0.2700" Y="0.0900" />
                        <FontResource Type="Normal" Path="fonts/font_wryh_b.ttf" Plist="" />
                        <OutlineColor A="255" R="0" G="0" B="0" />
                        <ShadowColor A="255" R="0" G="0" B="0" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_user_name3" ActionTag="1761568540" Tag="874" IconVisible="False" LeftMargin="44.2000" RightMargin="62.8000" TopMargin="66.2900" BottomMargin="115.7100" FontSize="15" LabelText="浪太大听不见" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="93.0000" Y="18.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="44.2000" Y="124.7100" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="216" G="117" B="67" />
                        <PrePosition X="0.2210" Y="0.6235" />
                        <PreSize X="0.4650" Y="0.0900" />
                        <FontResource Type="Normal" Path="fonts/font_wryh_b.ttf" Plist="" />
                        <OutlineColor A="255" R="0" G="0" B="0" />
                        <ShadowColor A="255" R="0" G="0" B="0" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_harm_rank_1" ActionTag="1025921803" VisibleForFrame="False" Tag="875" IconVisible="False" LeftMargin="6.8600" RightMargin="177.1400" TopMargin="65.6180" BottomMargin="116.3820" FontSize="15" LabelText="3." ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="16.0000" Y="18.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="6.8600" Y="125.3820" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="252" G="255" B="188" />
                        <PrePosition X="0.0343" Y="0.6269" />
                        <PreSize X="0.0800" Y="0.0900" />
                        <FontResource Type="Normal" Path="fonts/font_wryh_b.ttf" Plist="" />
                        <OutlineColor A="255" R="0" G="0" B="0" />
                        <ShadowColor A="255" R="0" G="0" B="0" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_harm_value4" ActionTag="2020516104" Tag="876" IconVisible="False" LeftMargin="155.1801" RightMargin="-16.1801" TopMargin="96.8900" BottomMargin="81.1100" FontSize="18" LabelText="4845万" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="61.0000" Y="22.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="155.1801" Y="92.1100" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.7759" Y="0.4606" />
                        <PreSize X="0.3050" Y="0.1100" />
                        <FontResource Type="Normal" Path="fonts/font_wryh_b.ttf" Plist="" />
                        <OutlineColor A="255" R="0" G="0" B="0" />
                        <ShadowColor A="255" R="0" G="0" B="0" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_user_name4" ActionTag="1003015103" Tag="877" IconVisible="False" LeftMargin="44.2000" RightMargin="44.8000" TopMargin="96.8900" BottomMargin="81.1100" FontSize="18" LabelText="浪太大听不见" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="111.0000" Y="22.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="44.2000" Y="92.1100" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.2210" Y="0.4606" />
                        <PreSize X="0.5550" Y="0.1100" />
                        <FontResource Type="Normal" Path="fonts/font_wryh_b.ttf" Plist="" />
                        <OutlineColor A="255" R="0" G="0" B="0" />
                        <ShadowColor A="255" R="0" G="0" B="0" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_harm_myRank" ActionTag="1926618359" Tag="878" IconVisible="False" LeftMargin="-16.1660" RightMargin="159.1660" TopMargin="97.3210" BottomMargin="80.6790" FontSize="18" LabelText="未上榜" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="57.0000" Y="22.0000" />
                        <AnchorPoint ScaleX="0.5029" ScaleY="0.5324" />
                        <Position X="12.4993" Y="92.3918" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.0625" Y="0.4620" />
                        <PreSize X="0.2850" Y="0.1100" />
                        <FontResource Type="Normal" Path="fonts/font_wryh_b.ttf" Plist="" />
                        <OutlineColor A="255" R="0" G="0" B="0" />
                        <ShadowColor A="255" R="0" G="0" B="0" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_damge_rank1" ActionTag="-1772803752" VisibleForFrame="False" Tag="538" IconVisible="False" LeftMargin="6.4558" RightMargin="179.5442" TopMargin="10.7777" BottomMargin="173.2223" LeftEage="4" RightEage="4" TopEage="5" BottomEage="5" Scale9OriginX="4" Scale9OriginY="5" Scale9Width="6" Scale9Height="6" ctype="ImageViewObjectData">
                        <Size X="14.0000" Y="16.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="13.4558" Y="181.2223" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.0673" Y="0.9061" />
                        <PreSize X="0.0700" Y="0.0800" />
                        <FileData Type="Normal" Path="newui/common/text/text_worldboss_rank1.png" Plist="" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_damge_rank2" ActionTag="-1306429907" VisibleForFrame="False" Tag="539" IconVisible="False" LeftMargin="6.6403" RightMargin="177.3597" TopMargin="38.2277" BottomMargin="145.7723" LeftEage="5" RightEage="5" TopEage="5" BottomEage="5" Scale9OriginX="5" Scale9OriginY="5" Scale9Width="6" Scale9Height="6" ctype="ImageViewObjectData">
                        <Size X="16.0000" Y="16.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="14.6403" Y="153.7723" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.0732" Y="0.7689" />
                        <PreSize X="0.0800" Y="0.0800" />
                        <FileData Type="Normal" Path="newui/common/text/text_worldboss_rank2.png" Plist="" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_damge_rank3" ActionTag="644578300" VisibleForFrame="False" Tag="540" IconVisible="False" LeftMargin="6.6400" RightMargin="176.3600" TopMargin="66.1205" BottomMargin="116.8795" LeftEage="5" RightEage="5" TopEage="5" BottomEage="5" Scale9OriginX="5" Scale9OriginY="5" Scale9Width="7" Scale9Height="7" ctype="ImageViewObjectData">
                        <Size X="17.0000" Y="17.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="15.1400" Y="125.3795" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.0757" Y="0.6269" />
                        <PreSize X="0.0850" Y="0.0850" />
                        <FileData Type="Normal" Path="newui/common/text/text_worldboss_rank3.png" Plist="" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_user_name1_0" ActionTag="369041431" Tag="366" IconVisible="False" LeftMargin="4.6900" RightMargin="182.3100" TopMargin="9.9700" BottomMargin="172.0300" FontSize="15" LabelText="1." ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="13.0000" Y="18.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="4.6900" Y="181.0300" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="240" B="75" />
                        <PrePosition X="0.0235" Y="0.9051" />
                        <PreSize X="0.0650" Y="0.0900" />
                        <FontResource Type="Normal" Path="fonts/font_wryh_b.ttf" Plist="" />
                        <OutlineColor A="255" R="0" G="0" B="0" />
                        <ShadowColor A="255" R="0" G="0" B="0" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_user_name2_0" ActionTag="-1038030441" Tag="367" IconVisible="False" LeftMargin="4.6900" RightMargin="179.3100" TopMargin="38.7100" BottomMargin="143.2900" FontSize="15" LabelText="2." ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="16.0000" Y="18.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="4.6900" Y="152.2900" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="206" G="214" B="227" />
                        <PrePosition X="0.0235" Y="0.7614" />
                        <PreSize X="0.0800" Y="0.0900" />
                        <FontResource Type="Normal" Path="fonts/font_wryh_b.ttf" Plist="" />
                        <OutlineColor A="255" R="0" G="0" B="0" />
                        <ShadowColor A="255" R="0" G="0" B="0" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_user_name3_0" ActionTag="-725953302" Tag="368" IconVisible="False" LeftMargin="4.6900" RightMargin="179.3100" TopMargin="66.2900" BottomMargin="115.7100" FontSize="15" LabelText="3." ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="16.0000" Y="18.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="4.6900" Y="124.7100" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="216" G="117" B="67" />
                        <PrePosition X="0.0235" Y="0.6235" />
                        <PreSize X="0.0800" Y="0.0900" />
                        <FontResource Type="Normal" Path="fonts/font_wryh_b.ttf" Plist="" />
                        <OutlineColor A="255" R="0" G="0" B="0" />
                        <ShadowColor A="255" R="0" G="0" B="0" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint />
                    <Position X="19.6431" Y="304.6766" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.0307" Y="0.6726" />
                    <PreSize X="0.3125" Y="0.4415" />
                    <SingleColor A="255" R="150" G="200" B="255" />
                    <FirstColor A="255" R="150" G="200" B="255" />
                    <EndColor A="255" R="255" G="255" B="255" />
                    <ColorVector ScaleY="1.0000" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="FileNode_tab_rank" ActionTag="2021962611" Tag="5655" IconVisible="True" VerticalEdge="TopEdge" RightMargin="640.0000" TopMargin="-112.2403" BottomMargin="565.2403" StretchWidthEnable="False" StretchHeightEnable="False" InnerActionSpeed="1.0000" CustomSizeEnabled="False" ctype="ProjectNodeObjectData">
                    <Size X="0.0000" Y="0.0000" />
                    <AnchorPoint />
                    <Position Y="565.2403" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition Y="1.2478" />
                    <PreSize X="0.0000" Y="0.0000" />
                    <FileData Type="Normal" Path="csb/common/CommonSmallTabButtons2.csd" Plist="" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Panel_inspire" ActionTag="-76923004" Tag="267" IconVisible="False" LeftMargin="523.0355" RightMargin="-83.0355" TopMargin="-61.6078" BottomMargin="314.6078" TouchEnable="True" ClipAble="False" BackColorAlpha="102" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
                    <Size X="200.0000" Y="200.0000" />
                    <Children>
                      <AbstractNodeData Name="Image_12" ActionTag="794698886" Tag="495" IconVisible="False" LeftMargin="-2.0900" RightMargin="57.0900" TopMargin="98.1787" BottomMargin="46.8213" LeftEage="57" RightEage="57" TopEage="8" BottomEage="8" Scale9OriginX="57" Scale9OriginY="8" Scale9Width="31" Scale9Height="39" ctype="ImageViewObjectData">
                        <Size X="145.0000" Y="55.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="70.4100" Y="74.3213" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.3521" Y="0.3716" />
                        <PreSize X="0.7250" Y="0.2750" />
                        <FileData Type="Normal" Path="newui/common/shade/img_shade_worldboss09.png" Plist="" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_5" ActionTag="-1570121835" Tag="421" IconVisible="False" LeftMargin="17.8317" RightMargin="98.1683" TopMargin="105.3593" BottomMargin="71.6407" FontSize="19" LabelText="攻击加成:" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="84.0000" Y="23.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="59.8317" Y="83.1407" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.2992" Y="0.4157" />
                        <PreSize X="0.4200" Y="0.1150" />
                        <FontResource Type="Normal" Path="fonts/font_wryh_b.ttf" Plist="" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_total_bonus" ActionTag="438992607" Tag="268" IconVisible="False" LeftMargin="31.2469" RightMargin="117.7531" TopMargin="128.0085" BottomMargin="46.9915" FontSize="19" LabelText="+30%" OutlineEnabled="True" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="51.0000" Y="25.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="56.7469" Y="59.4915" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="79" G="241" B="0" />
                        <PrePosition X="0.2837" Y="0.2975" />
                        <PreSize X="0.2550" Y="0.1250" />
                        <FontResource Type="Normal" Path="fonts/font_wryh_b.ttf" Plist="" />
                        <OutlineColor A="255" R="0" G="69" B="16" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Button_inspire" ActionTag="739869762" Tag="270" IconVisible="False" LeftMargin="28.6529" RightMargin="104.3471" TopMargin="16.0560" BottomMargin="117.9440" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="37" Scale9Height="44" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                        <Size X="67.0000" Y="66.0000" />
                        <Children>
                          <AbstractNodeData Name="Image_10" ActionTag="-256357555" Tag="420" IconVisible="False" LeftMargin="6.7183" RightMargin="15.2817" TopMargin="48.6624" BottomMargin="-9.6624" LeftEage="17" RightEage="17" TopEage="10" BottomEage="10" Scale9OriginX="17" Scale9OriginY="10" Scale9Width="11" Scale9Height="7" ctype="ImageViewObjectData">
                            <Size X="45.0000" Y="27.0000" />
                            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                            <Position X="29.2183" Y="3.8376" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition X="0.4361" Y="0.0581" />
                            <PreSize X="0.6716" Y="0.4091" />
                            <FileData Type="Normal" Path="newui/common/text/txt_sys_boss03.png" Plist="" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="Text_inspire" ActionTag="1539657189" VisibleForFrame="False" Tag="271" IconVisible="False" LeftMargin="6.2370" RightMargin="22.7630" TopMargin="33.8697" BottomMargin="-5.8697" FontSize="19" LabelText="鼓舞&#xA;" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                            <Size X="38.0000" Y="38.0000" />
                            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                            <Position X="25.2370" Y="13.1303" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="0" B="0" />
                            <PrePosition X="0.3767" Y="0.1989" />
                            <PreSize X="0.5672" Y="0.5758" />
                            <OutlineColor A="255" R="255" G="0" B="0" />
                            <ShadowColor A="255" R="110" G="110" B="110" />
                          </AbstractNodeData>
                        </Children>
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="62.1529" Y="150.9440" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.3108" Y="0.7547" />
                        <PreSize X="0.3350" Y="0.3300" />
                        <TextColor A="255" R="65" G="65" B="70" />
                        <DisabledFileData Type="Default" Path="Default/Button_Disable.png" Plist="" />
                        <PressedFileData Type="Normal" Path="newui/common/icon/icon_boss_inpire01.png" Plist="" />
                        <NormalFileData Type="Normal" Path="newui/common/icon/icon_boss_inpire01.png" Plist="" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint />
                    <Position X="523.0355" Y="314.6078" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.8172" Y="0.6945" />
                    <PreSize X="0.3125" Y="0.4415" />
                    <SingleColor A="255" R="150" G="200" B="255" />
                    <FirstColor A="255" R="150" G="200" B="255" />
                    <EndColor A="255" R="255" G="255" B="255" />
                    <ColorVector ScaleY="1.0000" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Panel_time" CanEdit="False" ActionTag="-1649604986" Tag="245" IconVisible="False" VerticalEdge="TopEdge" LeftMargin="6.1396" RightMargin="353.8604" TopMargin="-155.9850" BottomMargin="498.9850" ClipAble="False" BackColorAlpha="102" ColorAngle="90.0000" Scale9Enable="True" LeftEage="10" RightEage="100" TopEage="5" BottomEage="5" Scale9OriginX="-100" Scale9OriginY="-5" Scale9Width="110" Scale9Height="10" ctype="PanelObjectData">
                    <Size X="280.0000" Y="110.0000" />
                    <Children>
                      <AbstractNodeData Name="Image_exploit_bg" ActionTag="1724468653" Tag="246" IconVisible="False" PositionPercentYEnabled="True" LeftMargin="-377.9999" RightMargin="284.9999" TopMargin="-16.1480" BottomMargin="49.1480" FlipX="True" Scale9Enable="True" TopEage="20" BottomEage="20" Scale9OriginY="20" Scale9Width="373" Scale9Height="37" ctype="ImageViewObjectData">
                        <Size X="373.0000" Y="77.0000" />
                        <AnchorPoint ScaleX="1.0000" ScaleY="0.5000" />
                        <Position X="-4.9999" Y="87.6480" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="-0.0179" Y="0.7968" />
                        <PreSize X="1.3321" Y="0.7000" />
                        <FileData Type="Normal" Path="newui/common/shade/img_shade_worldboss01.png" Plist="" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_remaining_time" ActionTag="51812062" Tag="247" IconVisible="False" PositionPercentYEnabled="True" LeftMargin="41.0729" RightMargin="106.9271" TopMargin="-8.6280" BottomMargin="93.6280" FontSize="19" LabelText="BOSS挑战剩余：" OutlineEnabled="True" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="132.0000" Y="25.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="41.0729" Y="106.1280" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="250" G="240" B="73" />
                        <PrePosition X="0.1467" Y="0.9648" />
                        <PreSize X="0.4714" Y="0.2273" />
                        <FontResource Type="Normal" Path="fonts/font_wryh_b.ttf" Plist="" />
                        <OutlineColor A="255" R="100" G="11" B="9" />
                        <ShadowColor A="255" R="0" G="0" B="0" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_reward_tip" ActionTag="1591845501" Tag="248" IconVisible="False" PositionPercentYEnabled="True" LeftMargin="6.4926" RightMargin="-52.4926" TopMargin="28.2220" BottomMargin="56.7780" FontSize="19" LabelText="（内击杀，BOSS将升级并有丰厚奖励）" OutlineEnabled="True" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="326.0000" Y="25.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="6.4926" Y="69.2780" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.0232" Y="0.6298" />
                        <PreSize X="1.1643" Y="0.2273" />
                        <FontResource Type="Normal" Path="fonts/font_wryh_b.ttf" Plist="" />
                        <OutlineColor A="255" R="78" G="17" B="17" />
                        <ShadowColor A="255" R="0" G="0" B="0" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint />
                    <Position X="6.1396" Y="498.9850" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.0096" Y="1.1015" />
                    <PreSize X="0.4375" Y="0.2428" />
                    <SingleColor A="255" R="150" G="200" B="255" />
                    <FirstColor A="255" R="150" G="200" B="255" />
                    <EndColor A="255" R="255" G="255" B="255" />
                    <ColorVector ScaleY="1.0000" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleX="0.5000" ScaleY="1.0000" />
                <Position X="321.5360" Y="613.7335" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5024" Y="0.7195" />
                <PreSize X="1.0000" Y="0.5311" />
                <SingleColor A="255" R="150" G="200" B="255" />
                <FirstColor A="255" R="150" G="200" B="255" />
                <EndColor A="255" R="255" G="255" B="255" />
                <ColorVector ScaleY="1.0000" />
              </AbstractNodeData>
              <AbstractNodeData Name="Text_open_boss_time" ActionTag="-452359610" Tag="456" IconVisible="False" VerticalEdge="TopEdge" LeftMargin="46.5645" RightMargin="460.4355" TopMargin="73.8676" BottomMargin="752.1324" FontSize="19" LabelText="BOSS开启剩余：" OutlineSize="2" OutlineEnabled="True" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                <Size X="133.0000" Y="27.0000" />
                <AnchorPoint ScaleY="0.5000" />
                <Position X="46.5645" Y="765.6324" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="250" G="240" B="73" />
                <PrePosition X="0.0728" Y="0.8976" />
                <PreSize X="0.2078" Y="0.0317" />
                <FontResource Type="Normal" Path="fonts/font_wryh_b.ttf" Plist="" />
                <OutlineColor A="255" R="100" G="11" B="9" />
                <ShadowColor A="255" R="0" G="0" B="0" />
              </AbstractNodeData>
              <AbstractNodeData Name="Panel_bottomButtons" CanEdit="False" ActionTag="574875458" Tag="381" IconVisible="False" PositionPercentXEnabled="True" PercentWidthEnable="True" PercentWidthEnabled="True" VerticalEdge="BottomEdge" TopMargin="164.5000" BottomMargin="164.5000" ClipAble="False" BackColorAlpha="102" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
                <Size X="640.0000" Y="524.0000" />
                <Children>
                  <AbstractNodeData Name="Panel_noBoss_bottom" ActionTag="-1500641553" Tag="568" IconVisible="False" PositionPercentXEnabled="True" PercentWidthEnable="True" PercentWidthEnabled="True" TopMargin="544.0000" BottomMargin="-100.0000" ClipAble="False" BackColorAlpha="102" ColorAngle="90.0000" LeftEage="10" RightEage="100" TopEage="5" BottomEage="5" Scale9OriginX="-100" Scale9OriginY="-5" Scale9Width="110" Scale9Height="10" ctype="PanelObjectData">
                    <Size X="640.0000" Y="80.0000" />
                    <Children>
                      <AbstractNodeData Name="Text_noBoss_tip" ActionTag="-939837274" Tag="569" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="171.1511" RightMargin="157.9671" TopMargin="3.3447" BottomMargin="28.9573" IsCustomSize="True" FontSize="19" LabelText="饕餮叫醒存活，各位英雄再接再厉！" HorizontalAlignmentType="HT_Center" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="310.8818" Y="47.6981" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="326.5920" Y="52.8063" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.5103" Y="0.6601" />
                        <PreSize X="0.4858" Y="0.5962" />
                        <FontResource Type="Normal" Path="fonts/font_wryh_b.ttf" Plist="" />
                        <OutlineColor A="255" R="0" G="0" B="0" />
                        <ShadowColor A="255" R="0" G="0" B="0" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Image_barBg_magic" ActionTag="1692706263" VisibleForFrame="False" Tag="272" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="48.0000" RightMargin="48.0000" TopMargin="-42.9991" BottomMargin="86.9991" LeftEage="19" RightEage="19" TopEage="5" BottomEage="5" Scale9OriginX="19" Scale9OriginY="5" Scale9Width="256" Scale9Height="27" ctype="ImageViewObjectData">
                        <Size X="544.0000" Y="36.0000" />
                        <Children>
                          <AbstractNodeData Name="LoadingBar_progress_magic" ActionTag="-1716574433" Tag="273" IconVisible="False" PositionPercentYEnabled="True" PercentWidthEnable="True" PercentHeightEnable="True" PercentWidthEnabled="True" PercentHeightEnabled="True" ProgressInfo="100" ctype="LoadingBarObjectData">
                            <Size X="544.0000" Y="36.0000" />
                            <AnchorPoint ScaleY="0.5000" />
                            <Position Y="18.0000" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition Y="0.5000" />
                            <PreSize X="1.0000" Y="1.0000" />
                            <ImageFileData Type="Normal" Path="newui/common/img_bar_top05c.png" Plist="" />
                          </AbstractNodeData>
                        </Children>
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="320.0000" Y="104.9991" />
                        <Scale ScaleX="0.6000" ScaleY="0.8000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.5000" Y="1.3125" />
                        <PreSize X="0.8500" Y="0.4500" />
                        <FileData Type="Normal" Path="newui/common/img_bar_top05a.png" Plist="" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_bossMagicInfo" ActionTag="1381858156" VisibleForFrame="False" Tag="641" IconVisible="False" LeftMargin="91.0064" RightMargin="497.9936" TopMargin="-39.4993" BottomMargin="90.4993" FontSize="24" LabelText="魔值" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="51.0000" Y="29.0000" />
                        <AnchorPoint ScaleX="1.0000" ScaleY="0.5000" />
                        <Position X="142.0064" Y="104.9993" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="246" B="226" />
                        <PrePosition X="0.2219" Y="1.3125" />
                        <PreSize X="0.0797" Y="0.3625" />
                        <FontResource Type="Normal" Path="fonts/font_wryh_b.ttf" Plist="" />
                        <OutlineColor A="255" R="0" G="0" B="0" />
                        <ShadowColor A="255" R="0" G="0" B="0" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_bossMagic" ActionTag="-1481286372" VisibleForFrame="False" Tag="574" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="312.0000" RightMargin="312.0000" TopMargin="-51.0000" BottomMargin="79.0000" FontSize="22" LabelText="0&#xA;" HorizontalAlignmentType="HT_Center" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="16.0000" Y="52.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="320.0000" Y="105.0000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.5000" Y="1.3125" />
                        <PreSize X="0.0250" Y="0.6500" />
                        <FontResource Type="Normal" Path="fonts/font_wryh_b.ttf" Plist="" />
                        <OutlineColor A="255" R="0" G="0" B="0" />
                        <ShadowColor A="255" R="0" G="0" B="0" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="ProjectNode_book" ActionTag="1779467338" Tag="512" IconVisible="True" LeftMargin="324.9576" RightMargin="315.0424" TopMargin="-38.6936" BottomMargin="118.6936" StretchWidthEnable="False" StretchHeightEnable="False" InnerActionSpeed="1.0000" CustomSizeEnabled="False" ctype="ProjectNodeObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <AnchorPoint />
                        <Position X="324.9576" Y="118.6936" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.5077" Y="1.4837" />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="Normal" Path="csb/common/CommonButtonBigNode.csd" Plist="" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="0.5000" />
                    <Position X="320.0000" Y="-100.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.5000" Y="-0.1908" />
                    <PreSize X="1.0000" Y="0.1527" />
                    <SingleColor A="255" R="150" G="200" B="255" />
                    <FirstColor A="255" R="150" G="200" B="255" />
                    <EndColor A="255" R="255" G="255" B="255" />
                    <ColorVector ScaleY="1.0000" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Panel_boss_bottom" CanEdit="False" ActionTag="1370355936" Tag="1078" IconVisible="False" PositionPercentXEnabled="True" PercentWidthEnable="True" PercentWidthEnabled="True" TopMargin="544.0000" BottomMargin="-100.0000" ClipAble="False" BackColorAlpha="102" ColorAngle="90.0000" LeftEage="10" RightEage="100" TopEage="5" BottomEage="5" Scale9OriginX="-100" Scale9OriginY="-5" Scale9Width="110" Scale9Height="10" ctype="PanelObjectData">
                    <Size X="640.0000" Y="80.0000" />
                    <Children>
                      <AbstractNodeData Name="Text_left_challenge" ActionTag="417742885" VisibleForFrame="False" Tag="633" IconVisible="False" LeftMargin="246.0000" RightMargin="270.0000" TopMargin="24.5000" BottomMargin="32.5000" FontSize="19" LabelText="剩余挑战次数：" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="124.0000" Y="23.0000" />
                        <AnchorPoint ScaleX="1.0000" ScaleY="0.5000" />
                        <Position X="370.0000" Y="44.0000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="214" B="105" />
                        <PrePosition X="0.5781" Y="0.5500" />
                        <PreSize X="0.1937" Y="0.2875" />
                        <FontResource Type="Normal" Path="fonts/font_wryh_b.ttf" Plist="" />
                        <OutlineColor A="255" R="0" G="0" B="0" />
                        <ShadowColor A="255" R="0" G="0" B="0" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_left_challenge_times" ActionTag="2078310578" VisibleForFrame="False" Tag="708" IconVisible="False" LeftMargin="364.0000" RightMargin="243.0000" TopMargin="24.5000" BottomMargin="32.5000" FontSize="19" LabelText="0/0" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="33.0000" Y="23.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="364.0000" Y="44.0000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="214" B="105" />
                        <PrePosition X="0.5688" Y="0.5500" />
                        <PreSize X="0.0516" Y="0.2875" />
                        <FontResource Type="Normal" Path="fonts/font_wryh_b.ttf" Plist="" />
                        <OutlineColor A="255" R="0" G="0" B="0" />
                        <ShadowColor A="255" R="0" G="0" B="0" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Node_cd_show" ActionTag="-1546352463" Tag="683" IconVisible="True" RightMargin="640.0000" TopMargin="80.0000" ctype="SingleNodeObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <Children>
                          <AbstractNodeData Name="Text_next_challenge_time_0" ActionTag="-1570101104" Tag="3244" IconVisible="False" LeftMargin="201.9115" RightMargin="-275.9115" TopMargin="-145.3442" BottomMargin="120.3442" FontSize="19" LabelText="挑战CD：" OutlineEnabled="True" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                            <Size X="74.0000" Y="25.0000" />
                            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                            <Position X="238.9115" Y="132.8442" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <FontResource Type="Normal" Path="fonts/font_wryh_b.ttf" Plist="" />
                            <OutlineColor A="255" R="78" G="17" B="17" />
                            <ShadowColor A="255" R="0" G="0" B="0" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="Text_next_challenge_time" ActionTag="-136739325" Tag="528" IconVisible="False" LeftMargin="212.3669" RightMargin="-399.3669" TopMargin="-146.5700" BottomMargin="119.5700" FontSize="19" LabelText="00:00后方可继续挑战" OutlineSize="2" OutlineEnabled="True" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                            <Size X="187.0000" Y="27.0000" />
                            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                            <Position X="305.8669" Y="133.0700" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="250" G="240" B="73" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <FontResource Type="Normal" Path="fonts/font_wryh_b.ttf" Plist="" />
                            <OutlineColor A="255" R="100" G="11" B="9" />
                            <ShadowColor A="255" R="0" G="0" B="0" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="Button_clear_cd" ActionTag="-672883293" Tag="520" IconVisible="False" LeftMargin="383.0131" RightMargin="-423.0131" TopMargin="-142.5700" BottomMargin="123.5700" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="6" BottomEage="6" Scale9OriginX="15" Scale9OriginY="6" Scale9Width="10" Scale9Height="7" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                            <Size X="40.0000" Y="19.0000" />
                            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                            <Position X="403.0131" Y="133.0700" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <TextColor A="255" R="65" G="65" B="70" />
                            <NormalFileData Type="Normal" Path="newui/common/arrow/img_arrow_accelerate.png" Plist="" />
                            <OutlineColor A="255" R="255" G="0" B="0" />
                            <ShadowColor A="255" R="110" G="110" B="110" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="Panel_clear_cd" ActionTag="-213043234" Tag="301" IconVisible="False" LeftMargin="317.7650" RightMargin="-479.8526" TopMargin="-164.1731" BottomMargin="117.5378" TouchEnable="True" ClipAble="False" BackColorAlpha="102" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
                            <Size X="162.0876" Y="46.6353" />
                            <AnchorPoint />
                            <Position X="317.7650" Y="117.5378" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <SingleColor A="255" R="150" G="200" B="255" />
                            <FirstColor A="255" R="150" G="200" B="255" />
                            <EndColor A="255" R="255" G="255" B="255" />
                            <ColorVector ScaleY="1.0000" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="Text_cd_cost" ActionTag="1160091754" Tag="317" IconVisible="False" VerticalEdge="BottomEdge" LeftMargin="461.6174" RightMargin="-483.6174" TopMargin="-145.5700" BottomMargin="120.5700" FontSize="19" LabelText="10" OutlineEnabled="True" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                            <Size X="22.0000" Y="25.0000" />
                            <AnchorPoint ScaleY="0.5000" />
                            <Position X="461.6174" Y="133.0700" />
                            <Scale ScaleX="0.9467" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="240" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <FontResource Type="Normal" Path="fonts/font_wryh_b.ttf" Plist="" />
                            <OutlineColor A="255" R="78" G="17" B="17" />
                            <ShadowColor A="255" R="110" G="110" B="110" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="Image_11" ActionTag="1906456974" Tag="494" IconVisible="False" VerticalEdge="BottomEdge" LeftMargin="429.1215" RightMargin="-456.1215" TopMargin="-144.5700" BottomMargin="121.5700" LeftEage="13" RightEage="13" TopEage="7" BottomEage="7" Scale9OriginX="13" Scale9OriginY="7" Scale9Width="1" Scale9Height="9" ctype="ImageViewObjectData">
                            <Size X="27.0000" Y="23.0000" />
                            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                            <Position X="442.6215" Y="133.0700" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition />
                            <PreSize X="0.0000" Y="0.0000" />
                            <FileData Type="Normal" Path="newui/common/icon/icon_boss_yuanbao01.png" Plist="" />
                          </AbstractNodeData>
                        </Children>
                        <AnchorPoint />
                        <Position />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Panel_extraAward" ActionTag="-1854209645" VisibleForFrame="False" Tag="681" IconVisible="False" PositionPercentXEnabled="True" PercentWidthEnable="True" PercentWidthEnabled="True" TopMargin="-91.0003" BottomMargin="121.0003" ClipAble="False" BackColorAlpha="102" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
                        <Size X="640.0000" Y="50.0000" />
                        <Children>
                          <AbstractNodeData Name="Text_boss_extra_tip" ActionTag="-1878022900" VisibleForFrame="False" Tag="584" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="107.3920" RightMargin="180.6080" TopMargin="13.5000" BottomMargin="13.5000" FontSize="19" LabelText="在00:00:00内击杀BOSS所有人可获得大量" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                            <Size X="352.0000" Y="23.0000" />
                            <AnchorPoint ScaleX="1.0000" ScaleY="0.5000" />
                            <Position X="459.3920" Y="25.0000" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="238" G="225" B="207" />
                            <PrePosition X="0.7178" Y="0.5000" />
                            <PreSize X="0.5500" Y="0.4600" />
                            <FontResource Type="Normal" Path="fonts/font_wryh_b.ttf" Plist="" />
                            <OutlineColor A="255" R="0" G="0" B="0" />
                            <ShadowColor A="255" R="0" G="0" B="0" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="Text_boss_extra_tip1" ActionTag="603833170" VisibleForFrame="False" Tag="514" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="498.3000" RightMargin="120.7000" TopMargin="13.5000" BottomMargin="13.5000" FontSize="19" LabelText="和" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                            <Size X="21.0000" Y="23.0000" />
                            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                            <Position X="508.8000" Y="25.0000" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="238" G="225" B="207" />
                            <PrePosition X="0.7950" Y="0.5000" />
                            <PreSize X="0.0328" Y="0.4600" />
                            <FontResource Type="Normal" Path="fonts/font_wryh_b.ttf" Plist="" />
                            <OutlineColor A="255" R="0" G="0" B="0" />
                            <ShadowColor A="255" R="0" G="0" B="0" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="Image_extra_fali" ActionTag="-23450641" VisibleForFrame="False" Tag="593" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="518.0640" RightMargin="85.9360" TopMargin="7.0000" BottomMargin="7.0000" Scale9Width="36" Scale9Height="36" ctype="ImageViewObjectData">
                            <Size X="36.0000" Y="36.0000" />
                            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                            <Position X="536.0640" Y="25.0000" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition X="0.8376" Y="0.5000" />
                            <PreSize X="0.0562" Y="0.7200" />
                            <FileData Type="Normal" Path="newui/uiicon/miniicon/200010.png" Plist="" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="Image_extra_gold" ActionTag="-456722905" VisibleForFrame="False" Tag="506" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="461.0400" RightMargin="142.9600" TopMargin="7.0000" BottomMargin="7.0000" Scale9Width="36" Scale9Height="36" ctype="ImageViewObjectData">
                            <Size X="36.0000" Y="36.0000" />
                            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                            <Position X="479.0400" Y="25.0000" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition X="0.7485" Y="0.5000" />
                            <PreSize X="0.0562" Y="0.7200" />
                            <FileData Type="Normal" Path="newui/uiicon/miniicon/100011.png" Plist="" />
                          </AbstractNodeData>
                        </Children>
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="320.0000" Y="146.0003" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.5000" Y="1.8250" />
                        <PreSize X="1.0000" Y="0.6250" />
                        <SingleColor A="255" R="150" G="200" B="255" />
                        <FirstColor A="255" R="150" G="200" B="255" />
                        <EndColor A="255" R="255" G="255" B="255" />
                        <ColorVector ScaleY="1.0000" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Panel_normalAward" Visible="False" ActionTag="1696979276" Tag="509" IconVisible="False" PositionPercentXEnabled="True" PercentWidthEnable="True" PercentWidthEnabled="True" TopMargin="-91.0000" BottomMargin="121.0000" ClipAble="False" BackColorAlpha="102" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
                        <Size X="640.0000" Y="50.0000" />
                        <Children>
                          <AbstractNodeData Name="Text_boss_normal_tip" ActionTag="1383567750" VisibleForFrame="False" Tag="510" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="193.4240" RightMargin="208.5760" TopMargin="13.5000" BottomMargin="13.5000" FontSize="19" LabelText="击杀BOSS所有人可获得大量" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                            <Size X="238.0000" Y="23.0000" />
                            <AnchorPoint ScaleX="1.0000" ScaleY="0.5000" />
                            <Position X="431.4240" Y="25.0000" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="238" G="225" B="207" />
                            <PrePosition X="0.6741" Y="0.5000" />
                            <PreSize X="0.3719" Y="0.4600" />
                            <FontResource Type="Normal" Path="fonts/font_wryh_b.ttf" Plist="" />
                            <OutlineColor A="255" R="0" G="0" B="0" />
                            <ShadowColor A="255" R="0" G="0" B="0" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="Image_normal_gold" ActionTag="1483386110" VisibleForFrame="False" Tag="513" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="433.0720" RightMargin="170.9280" TopMargin="7.0000" BottomMargin="7.0000" Scale9Width="36" Scale9Height="36" ctype="ImageViewObjectData">
                            <Size X="36.0000" Y="36.0000" />
                            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                            <Position X="451.0720" Y="25.0000" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition X="0.7048" Y="0.5000" />
                            <PreSize X="0.0562" Y="0.7200" />
                            <FileData Type="Normal" Path="newui/uiicon/miniicon/100011.png" Plist="" />
                          </AbstractNodeData>
                        </Children>
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="320.0000" Y="146.0000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.5000" Y="1.8250" />
                        <PreSize X="1.0000" Y="0.6250" />
                        <SingleColor A="255" R="150" G="200" B="255" />
                        <FirstColor A="255" R="150" G="200" B="255" />
                        <EndColor A="255" R="255" G="255" B="255" />
                        <ColorVector ScaleY="1.0000" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="ProjectNode_attack" ActionTag="-997658499" Tag="792" IconVisible="True" LeftMargin="325.5950" RightMargin="314.4050" TopMargin="-0.5132" BottomMargin="80.5132" StretchWidthEnable="False" StretchHeightEnable="False" InnerActionSpeed="1.0000" CustomSizeEnabled="False" ctype="ProjectNodeObjectData">
                        <Size X="0.0000" Y="0.0000" />
                        <AnchorPoint />
                        <Position X="325.5950" Y="80.5132" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.5087" Y="1.0064" />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="Normal" Path="csb/common/CommonButtonBigNode.csd" Plist="" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Button_attack" CanEdit="False" ActionTag="-26942253" VisibleForFrame="False" Tag="316" IconVisible="False" LeftMargin="430.4715" RightMargin="63.5285" TopMargin="-31.6776" BottomMargin="75.6776" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="16" Scale9Height="14" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                        <Size X="146.0000" Y="36.0000" />
                        <Children>
                          <AbstractNodeData Name="Text_attack" CanEdit="False" ActionTag="-1643581114" Tag="318" IconVisible="False" LeftMargin="100.8752" RightMargin="7.1248" TopMargin="11.8477" BottomMargin="5.1523" FontSize="19" LabelText="挑战" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                            <Size X="38.0000" Y="19.0000" />
                            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                            <Position X="119.8752" Y="14.6523" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="0" B="0" />
                            <PrePosition X="0.8211" Y="0.4070" />
                            <PreSize X="0.2603" Y="0.5278" />
                            <OutlineColor A="255" R="255" G="0" B="0" />
                            <ShadowColor A="255" R="110" G="110" B="110" />
                          </AbstractNodeData>
                        </Children>
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="503.4715" Y="93.6776" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.7867" Y="1.1710" />
                        <PreSize X="0.2281" Y="0.4500" />
                        <TextColor A="255" R="65" G="65" B="70" />
                        <DisabledFileData Type="Default" Path="Default/Button_Disable.png" Plist="" />
                        <PressedFileData Type="Default" Path="Default/Button_Press.png" Plist="" />
                        <NormalFileData Type="Default" Path="Default/Button_Normal.png" Plist="" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="009_yellow" ActionTag="1330448561" VisibleForFrame="False" Alpha="191" Tag="505" IconVisible="False" LeftMargin="71.2418" RightMargin="501.7582" TopMargin="-24.0112" BottomMargin="79.0112" FontSize="19" LabelText="清除CD" OutlineEnabled="True" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="67.0000" Y="25.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="104.7418" Y="91.5112" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="250" G="240" B="73" />
                        <PrePosition X="0.1637" Y="1.1439" />
                        <PreSize X="0.1047" Y="0.3125" />
                        <FontResource Type="Normal" Path="fonts/font_wryh_b.ttf" Plist="" />
                        <OutlineColor A="255" R="100" G="6" B="9" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="0012_white" ActionTag="-2000812352" VisibleForFrame="False" Tag="519" IconVisible="False" LeftMargin="63.1504" RightMargin="422.8496" TopMargin="10.7570" BottomMargin="50.2430" FontSize="14" LabelText="(清除CD会自动消耗元宝)" OutlineEnabled="True" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="154.0000" Y="19.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="140.1504" Y="59.7430" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.2190" Y="0.7468" />
                        <PreSize X="0.2406" Y="0.2375" />
                        <FontResource Type="Normal" Path="fonts/font_wryh_b.ttf" Plist="" />
                        <OutlineColor A="255" R="78" G="17" B="17" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Panel_auto_fight" ActionTag="1545470770" Tag="264" IconVisible="False" LeftMargin="440.1221" RightMargin="-0.1221" TopMargin="-37.8615" BottomMargin="36.0752" TouchEnable="True" ClipAble="False" BackColorAlpha="102" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
                        <Size X="200.0000" Y="81.7863" />
                        <Children>
                          <AbstractNodeData Name="CheckBox_auto_fight" ActionTag="-777876486" Tag="265" IconVisible="False" LeftMargin="49.0268" RightMargin="105.9732" TopMargin="15.0624" BottomMargin="21.7239" ctype="CheckBoxObjectData">
                            <Size X="45.0000" Y="45.0000" />
                            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                            <Position X="71.5268" Y="44.2239" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition X="0.3576" Y="0.5407" />
                            <PreSize X="0.2250" Y="0.5502" />
                            <NormalBackFileData Type="Normal" Path="newui/common/checkbox/check_box04.png" Plist="" />
                            <PressedBackFileData Type="Normal" Path="newui/common/checkbox/check_box04.png" Plist="" />
                            <DisableBackFileData Type="Normal" Path="newui/common/checkbox/check_box04.png" Plist="" />
                            <NodeNormalFileData Type="Normal" Path="newui/common/checkbox/icon_check_box04.png" Plist="" />
                            <NodeDisableFileData Type="Default" Path="Default/CheckBoxNode_Disable.png" Plist="" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="Text_auto_fight" ActionTag="-1877475338" Tag="266" IconVisible="False" LeftMargin="-28.0658" RightMargin="153.0658" TopMargin="27.1234" BottomMargin="32.6629" FontSize="18" LabelText="自动战斗" HorizontalAlignmentType="HT_Center" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                            <Size X="75.0000" Y="22.0000" />
                            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                            <Position X="9.4342" Y="43.6629" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="249" B="153" />
                            <PrePosition X="0.0472" Y="0.5339" />
                            <PreSize X="0.3750" Y="0.2690" />
                            <FontResource Type="Normal" Path="fonts/font_wryh_b.ttf" Plist="" />
                            <OutlineColor A="255" R="255" G="0" B="0" />
                            <ShadowColor A="255" R="110" G="110" B="110" />
                          </AbstractNodeData>
                        </Children>
                        <AnchorPoint />
                        <Position X="440.1221" Y="36.0752" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.6877" Y="0.4509" />
                        <PreSize X="0.3125" Y="1.0223" />
                        <SingleColor A="255" R="150" G="200" B="255" />
                        <FirstColor A="255" R="150" G="200" B="255" />
                        <EndColor A="255" R="255" G="255" B="255" />
                        <ColorVector ScaleY="1.0000" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="0.5000" />
                    <Position X="320.0000" Y="-100.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.5000" Y="-0.1908" />
                    <PreSize X="1.0000" Y="0.1527" />
                    <SingleColor A="255" R="150" G="200" B="255" />
                    <FirstColor A="255" R="150" G="200" B="255" />
                    <EndColor A="255" R="255" G="255" B="255" />
                    <ColorVector ScaleY="1.0000" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Image_barBg_hp" ActionTag="1003873320" Tag="579" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="175.8520" RightMargin="167.1480" TopMargin="446.0088" BottomMargin="56.9912" LeftEage="19" RightEage="19" TopEage="5" BottomEage="5" Scale9OriginX="19" Scale9OriginY="5" Scale9Width="259" Scale9Height="11" ctype="ImageViewObjectData">
                    <Size X="297.0000" Y="21.0000" />
                    <Children>
                      <AbstractNodeData Name="Image_82" ActionTag="-1879837556" VisibleForFrame="False" Tag="797" IconVisible="False" LeftMargin="5.7348" RightMargin="-7.7348" TopMargin="3.2085" BottomMargin="3.7915" LeftEage="98" RightEage="98" TopEage="4" BottomEage="4" Scale9OriginX="98" Scale9OriginY="4" Scale9Width="103" Scale9Height="6" ctype="ImageViewObjectData">
                        <Size X="299.0000" Y="14.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="155.2348" Y="10.7915" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.5227" Y="0.5139" />
                        <PreSize X="1.0067" Y="0.6667" />
                        <FileData Type="Normal" Path="newui/common/loadingbar/img_bar_worldboss01b.png" Plist="" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="LoadingBar_progress_hp" ActionTag="734735358" Tag="580" IconVisible="False" LeftMargin="2.9809" RightMargin="3.0191" TopMargin="2.0000" BottomMargin="3.0000" ProgressInfo="100" ctype="LoadingBarObjectData">
                        <Size X="291.0000" Y="16.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="2.9809" Y="11.0000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.0100" Y="0.5238" />
                        <PreSize X="0.9798" Y="0.7619" />
                        <ImageFileData Type="Normal" Path="newui/common/loadingbar/img_bar_worldboss02c.png" Plist="" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_bossHP" ActionTag="626728628" Tag="581" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="139.4556" RightMargin="142.5444" TopMargin="-2.4095" BottomMargin="-1.5905" FontSize="19" LabelText="0" OutlineEnabled="True" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="15.0000" Y="25.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="146.9556" Y="10.9095" />
                        <Scale ScaleX="1.0000" ScaleY="0.8975" />
                        <CColor A="255" R="250" G="240" B="73" />
                        <PrePosition X="0.4948" Y="0.5195" />
                        <PreSize X="0.0505" Y="1.1905" />
                        <FontResource Type="Normal" Path="fonts/font_wryh_b.ttf" Plist="" />
                        <OutlineColor A="255" R="100" G="11" B="9" />
                        <ShadowColor A="255" R="0" G="0" B="0" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="324.3520" Y="67.4912" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.5068" Y="0.1288" />
                    <PreSize X="0.4641" Y="0.0401" />
                    <FileData Type="Normal" Path="newui/common/loadingbar/img_bar_worldboss02b.png" Plist="" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleY="0.5000" />
                <Position Y="426.5000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition Y="0.5000" />
                <PreSize X="1.0000" Y="0.6143" />
                <SingleColor A="255" R="150" G="200" B="255" />
                <FirstColor A="255" R="150" G="200" B="255" />
                <EndColor A="255" R="255" G="255" B="255" />
                <ColorVector ScaleY="1.0000" />
              </AbstractNodeData>
              <AbstractNodeData Name="Button_lineup" ActionTag="-1270867887" Tag="142" IconVisible="False" VerticalEdge="BottomEdge" LeftMargin="550.8500" RightMargin="17.1500" TopMargin="661.1686" BottomMargin="105.8314" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="42" Scale9Height="64" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                <Size X="72.0000" Y="86.0000" />
                <Children>
                  <AbstractNodeData Name="Image_10" ActionTag="-78935029" Tag="143" IconVisible="False" LeftMargin="14.7747" RightMargin="12.2253" TopMargin="52.7305" BottomMargin="6.2695" LeftEage="17" RightEage="17" TopEage="10" BottomEage="10" Scale9OriginX="17" Scale9OriginY="10" Scale9Width="11" Scale9Height="7" ctype="ImageViewObjectData">
                    <Size X="45.0000" Y="27.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="37.2747" Y="19.7695" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.5177" Y="0.2299" />
                    <PreSize X="0.6250" Y="0.3140" />
                    <FileData Type="Normal" Path="newui/common/text/text_lineup.png" Plist="" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Text_inspire" ActionTag="1178873941" VisibleForFrame="False" Tag="144" IconVisible="False" LeftMargin="6.2370" RightMargin="27.7630" TopMargin="63.3697" BottomMargin="3.6303" FontSize="19" LabelText="布阵" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                    <Size X="38.0000" Y="19.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="25.2370" Y="13.1303" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="0" B="0" />
                    <PrePosition X="0.3505" Y="0.1527" />
                    <PreSize X="0.5278" Y="0.2209" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="586.8500" Y="148.8314" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.9170" Y="0.1745" />
                <PreSize X="0.1125" Y="0.1008" />
                <TextColor A="255" R="65" G="65" B="70" />
                <DisabledFileData Type="Default" Path="Default/Button_Disable.png" Plist="" />
                <PressedFileData Type="Normal" Path="newui/uiicon/icon/icon_lv1_buzhen.png" Plist="" />
                <NormalFileData Type="Normal" Path="newui/uiicon/icon/icon_lv1_buzhen.png" Plist="" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="Button_shop" ActionTag="-1071274454" Tag="1090" IconVisible="False" HorizontalEdge="RightEdge" VerticalEdge="BottomEdge" LeftMargin="7.2339" RightMargin="552.7661" TopMargin="657.1321" BottomMargin="115.8679" TouchEnable="True" FontSize="22" LeftEage="21" RightEage="21" TopEage="21" BottomEage="21" Scale9OriginX="21" Scale9OriginY="21" Scale9Width="38" Scale9Height="38" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                <Size X="80.0000" Y="80.0000" />
                <Children>
                  <AbstractNodeData Name="Image_red_dot" ActionTag="306683136" Tag="1091" IconVisible="False" LeftMargin="53.3151" RightMargin="4.6849" TopMargin="5.2273" BottomMargin="52.7727" Scale9Width="22" Scale9Height="22" ctype="ImageViewObjectData">
                    <Size X="22.0000" Y="22.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="64.3151" Y="63.7727" />
                    <Scale ScaleX="0.8000" ScaleY="0.8000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.8039" Y="0.7972" />
                    <PreSize X="0.2750" Y="0.2750" />
                    <FileData Type="Normal" Path="newui/common/img_com_btn_tipred01.png" Plist="" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Text_shop" ActionTag="-797409346" VisibleForFrame="False" Tag="1092" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="-2.4240" RightMargin="2.4240" TopMargin="74.1523" BottomMargin="-21.1523" FontSize="19" LabelText="声望商店" OutlineSize="2" OutlineEnabled="True" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                    <Size X="80.0000" Y="27.0000" />
                    <AnchorPoint ScaleX="0.5000" />
                    <Position X="37.5760" Y="-21.1523" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="250" G="240" B="73" />
                    <PrePosition X="0.4697" Y="-0.2644" />
                    <PreSize X="1.0000" Y="0.3375" />
                    <FontResource Type="Normal" Path="fonts/font_wryh_b.ttf" Plist="" />
                    <OutlineColor A="255" R="100" G="11" B="9" />
                    <ShadowColor A="255" R="0" G="0" B="0" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Sprite_rank_0" ActionTag="591689484" Tag="683" IconVisible="False" LeftMargin="-2.0676" RightMargin="-1.9324" TopMargin="58.7446" BottomMargin="-5.7446" ctype="SpriteObjectData">
                    <Size X="84.0000" Y="27.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="39.9324" Y="7.7554" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.4992" Y="0.0969" />
                    <PreSize X="1.0500" Y="0.3375" />
                    <FileData Type="Normal" Path="newui/common/text/text_boss_sw.png" Plist="" />
                    <BlendFunc Src="770" Dst="771" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="47.2339" Y="155.8679" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.0738" Y="0.1827" />
                <PreSize X="0.1250" Y="0.0938" />
                <FontResource Type="Normal" Path="fonts/font_wryh_b.ttf" Plist="" />
                <TextColor A="255" R="0" G="0" B="0" />
                <NormalFileData Type="Normal" Path="newui/uiicon/icon/main_lv2_baohe.png" Plist="" />
                <OutlineColor A="255" R="0" G="0" B="0" />
                <ShadowColor A="255" R="0" G="0" B="0" />
              </AbstractNodeData>
              <AbstractNodeData Name="Button_rank" ActionTag="1007091103" Tag="1055" IconVisible="False" LeftMargin="92.4173" RightMargin="467.5827" TopMargin="662.1047" BottomMargin="110.8953" TouchEnable="True" FontSize="32" LeftEage="29" RightEage="29" TopEage="29" BottomEage="29" Scale9OriginX="29" Scale9OriginY="29" Scale9Width="22" Scale9Height="22" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                <Size X="80.0000" Y="80.0000" />
                <Children>
                  <AbstractNodeData Name="Text_shop_0" ActionTag="1001080225" VisibleForFrame="False" Tag="1115" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="10.2720" RightMargin="7.7280" TopMargin="55.4160" BottomMargin="-2.4160" FontSize="19" LabelText="排行榜" OutlineSize="2" OutlineEnabled="True" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                    <Size X="62.0000" Y="27.0000" />
                    <AnchorPoint ScaleX="0.5000" />
                    <Position X="41.2720" Y="-2.4160" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="250" G="240" B="73" />
                    <PrePosition X="0.5159" Y="-0.0302" />
                    <PreSize X="0.7750" Y="0.3375" />
                    <FontResource Type="Normal" Path="fonts/font_wryh_b.ttf" Plist="" />
                    <OutlineColor A="255" R="100" G="11" B="9" />
                    <ShadowColor A="255" R="0" G="0" B="0" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Text_rank_btn" ActionTag="1262345344" VisibleForFrame="False" Tag="1056" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="40.0000" RightMargin="40.0000" TopMargin="85.0000" BottomMargin="-5.0000" FontSize="22" LabelText="" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                    <Size X="0.0000" Y="0.0000" />
                    <AnchorPoint ScaleX="0.5000" />
                    <Position X="40.0000" Y="-5.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.5000" Y="-0.0625" />
                    <PreSize X="0.0000" Y="0.0000" />
                    <FontResource Type="Normal" Path="fonts/font_wryh_b.ttf" Plist="" />
                    <OutlineColor A="255" R="0" G="0" B="0" />
                    <ShadowColor A="255" R="0" G="0" B="0" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Sprite_rank" ActionTag="-1811188734" Tag="682" IconVisible="False" LeftMargin="6.7892" RightMargin="8.2108" TopMargin="53.8611" BottomMargin="-0.8611" ctype="SpriteObjectData">
                    <Size X="65.0000" Y="27.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="39.2892" Y="12.6389" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.4911" Y="0.1580" />
                    <PreSize X="0.8125" Y="0.3375" />
                    <FileData Type="Normal" Path="newui/common/text/text_tower_rank.png" Plist="" />
                    <BlendFunc Src="770" Dst="771" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="132.4173" Y="150.8953" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.2069" Y="0.1769" />
                <PreSize X="0.1250" Y="0.0938" />
                <TextColor A="255" R="255" G="255" B="255" />
                <NormalFileData Type="Normal" Path="newui/uiicon/icon/main_lv2_rank.png" Plist="" />
                <OutlineColor A="255" R="0" G="0" B="0" />
                <ShadowColor A="255" R="0" G="0" B="0" />
              </AbstractNodeData>
              <AbstractNodeData Name="Button_reward_show" ActionTag="-785368119" Tag="518" IconVisible="False" VerticalEdge="TopEdge" LeftMargin="553.4794" RightMargin="26.5206" TopMargin="123.3313" BottomMargin="665.6687" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="30" Scale9Height="42" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                <Size X="60.0000" Y="64.0000" />
                <Children>
                  <AbstractNodeData Name="Image_10" ActionTag="333073321" Tag="519" IconVisible="False" LeftMargin="-12.9012" RightMargin="-11.0988" TopMargin="41.9905" BottomMargin="-4.9905" LeftEage="17" RightEage="17" TopEage="10" BottomEage="10" Scale9OriginX="17" Scale9OriginY="10" Scale9Width="50" Scale9Height="7" ctype="ImageViewObjectData">
                    <Size X="84.0000" Y="27.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="29.0988" Y="8.5095" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.4850" Y="0.1330" />
                    <PreSize X="1.4000" Y="0.4219" />
                    <FileData Type="Normal" Path="newui/common/text/text_worldboss_reward01.png" Plist="" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Text_inspire" ActionTag="980848261" VisibleForFrame="False" Tag="520" IconVisible="False" LeftMargin="6.2370" RightMargin="15.7630" TopMargin="41.3697" BottomMargin="3.6303" FontSize="19" LabelText="布阵" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                    <Size X="38.0000" Y="19.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="25.2370" Y="13.1303" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="0" B="0" />
                    <PrePosition X="0.4206" Y="0.2052" />
                    <PreSize X="0.6333" Y="0.2969" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="583.4794" Y="697.6687" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.9117" Y="0.8179" />
                <PreSize X="0.0938" Y="0.0750" />
                <TextColor A="255" R="65" G="65" B="70" />
                <DisabledFileData Type="Default" Path="Default/Button_Disable.png" Plist="" />
                <NormalFileData Type="Normal" Path="newui/common/icon/icon_boss_reward01.png" Plist="" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint />
            <Position />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="1.0000" Y="1.0000" />
            <SingleColor A="255" R="150" G="200" B="255" />
            <FirstColor A="255" R="150" G="200" B="255" />
            <EndColor A="255" R="255" G="255" B="255" />
            <ColorVector ScaleY="1.0000" />
          </AbstractNodeData>
        </Children>
      </ObjectData>
    </Content>
  </Content>
</GameFile>