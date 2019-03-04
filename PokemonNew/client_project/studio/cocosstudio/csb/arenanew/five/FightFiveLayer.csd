<GameFile>
  <PropertyGroup Name="FightFiveLayer" Type="Layer" ID="3b59941f-790e-4310-9e76-6fe06cb4b501" Version="3.10.0.0" />
  <Content ctype="GameProjectContent">
    <Content>
      <Animation Duration="0" Speed="1.0000" />
      <ObjectData Name="Layer" Tag="383" ctype="GameLayerObjectData">
        <Size X="640.0000" Y="960.0000" />
        <Children>
          <AbstractNodeData Name="image_bg" ActionTag="-352730925" Tag="388" IconVisible="False" HorizontalEdge="BothEdge" VerticalEdge="BottomEdge" TopMargin="-180.0000" Scale9Width="480" Scale9Height="855" ctype="ImageViewObjectData">
            <Size X="640.0000" Y="1140.0000" />
            <AnchorPoint ScaleX="0.5000" />
            <Position X="320.0000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.5000" />
            <PreSize X="1.0000" Y="1.1875" />
            <FileData Type="Normal" Path="newui/background/bg_mission03.jpg" Plist="" />
          </AbstractNodeData>
          <AbstractNodeData Name="Panel_7" ActionTag="-171717347" Tag="228" IconVisible="False" TopMargin="83.0000" BottomMargin="87.0000" ClipAble="True" BackColorAlpha="102" ColorAngle="90.0000" ctype="PanelObjectData">
            <Size X="640.0000" Y="790.0000" />
            <Children>
              <AbstractNodeData Name="ListView" ActionTag="620407188" Tag="540" IconVisible="False" LeftMargin="30.0000" RightMargin="30.0000" TouchEnable="True" ClipAble="False" BackColorAlpha="102" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" IsBounceEnabled="True" ScrollDirectionType="0" ItemMargin="5" DirectionType="Vertical" ctype="ListViewObjectData">
                <Size X="580.0000" Y="790.0000" />
                <AnchorPoint />
                <Position X="30.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.0469" />
                <PreSize X="0.9063" Y="0.8229" />
                <SingleColor A="255" R="150" G="150" B="255" />
                <FirstColor A="255" R="150" G="150" B="255" />
                <EndColor A="255" R="255" G="255" B="255" />
                <ColorVector ScaleY="1.0000" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint />
            <Position Y="87.0000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition Y="0.0906" />
            <PreSize X="1.0000" Y="0.8229" />
            <SingleColor A="255" R="150" G="200" B="255" />
            <FirstColor A="255" R="150" G="200" B="255" />
            <EndColor A="255" R="255" G="255" B="255" />
            <ColorVector ScaleY="1.0000" />
          </AbstractNodeData>
          <AbstractNodeData Name="panel_holder" ActionTag="1046116438" Tag="389" IconVisible="True" StretchWidthEnable="False" StretchHeightEnable="False" InnerActionSpeed="1.0000" CustomSizeEnabled="False" ctype="ProjectNodeObjectData">
            <Size X="640.0000" Y="960.0000" />
            <AnchorPoint />
            <Position />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="1.0000" Y="1.0000" />
            <FileData Type="Normal" Path="csb/common/CommonFullListLayer1.csd" Plist="" />
          </AbstractNodeData>
          <AbstractNodeData Name="ProjectNode_finish" ActionTag="-253357153" Tag="402" IconVisible="True" LeftMargin="320.0000" RightMargin="320.0000" TopMargin="920.0000" BottomMargin="40.0000" StretchWidthEnable="False" StretchHeightEnable="False" InnerActionSpeed="1.0000" CustomSizeEnabled="False" ctype="ProjectNodeObjectData">
            <Size X="0.0000" Y="0.0000" />
            <AnchorPoint />
            <Position X="320.0000" Y="40.0000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.5000" Y="0.0417" />
            <PreSize X="0.0000" Y="0.0000" />
            <FileData Type="Normal" Path="csb/common/CommonButtonBigNode.csd" Plist="" />
          </AbstractNodeData>
          <AbstractNodeData Name="panel_energy" ActionTag="-491946393" Tag="468" IconVisible="False" LeftMargin="20.0000" RightMargin="420.0000" TopMargin="895.0000" BottomMargin="15.0000" TouchEnable="True" ClipAble="False" BackColorAlpha="102" ColorAngle="90.0000" ctype="PanelObjectData">
            <Size X="200.0000" Y="50.0000" />
            <Children>
              <AbstractNodeData Name="label_energy" ActionTag="-1208526908" Tag="831" IconVisible="False" LeftMargin="105.0000" RightMargin="37.0000" TopMargin="-2.5000" BottomMargin="27.5000" FontSize="22" LabelText="10/30" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                <Size X="58.0000" Y="25.0000" />
                <AnchorPoint ScaleY="0.5000" />
                <Position X="105.0000" Y="40.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5250" Y="0.8000" />
                <PreSize X="0.4433" Y="0.6944" />
                <FontResource Type="Normal" Path="fonts/font_wryh_b.ttf" Plist="" />
              </AbstractNodeData>
              <AbstractNodeData Name="label_cost" ActionTag="-868898632" Tag="375" IconVisible="False" LeftMargin="105.0000" RightMargin="83.0000" TopMargin="24.5000" BottomMargin="0.5000" FontSize="22" LabelText="2" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                <Size X="12.0000" Y="25.0000" />
                <AnchorPoint ScaleY="0.5000" />
                <Position X="105.0000" Y="13.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5250" Y="0.2600" />
                <PreSize X="0.4433" Y="0.6944" />
                <FontResource Type="Normal" Path="fonts/font_wryh_b.ttf" Plist="" />
              </AbstractNodeData>
              <AbstractNodeData Name="label_energy_title" ActionTag="1953445594" Tag="376" IconVisible="False" LeftMargin="-10.0000" RightMargin="100.0000" TopMargin="-2.5000" BottomMargin="27.5000" FontSize="22" LabelText="当前精力：" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                <Size X="110.0000" Y="25.0000" />
                <AnchorPoint ScaleX="1.0000" ScaleY="0.5000" />
                <Position X="100.0000" Y="40.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="214" G="208" B="112" />
                <PrePosition X="0.5000" Y="0.8000" />
                <PreSize X="0.4433" Y="0.6944" />
                <FontResource Type="Normal" Path="fonts/font_wryh_b.ttf" Plist="" />
              </AbstractNodeData>
              <AbstractNodeData Name="label_cost_title" ActionTag="542398047" Tag="438" IconVisible="False" LeftMargin="-10.0000" RightMargin="100.0000" TopMargin="24.5000" BottomMargin="0.5000" FontSize="22" LabelText="消耗精力：" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                <Size X="110.0000" Y="25.0000" />
                <AnchorPoint ScaleX="1.0000" ScaleY="0.5000" />
                <Position X="100.0000" Y="13.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="214" G="208" B="112" />
                <PrePosition X="0.5000" Y="0.2600" />
                <PreSize X="0.4433" Y="0.6944" />
                <FontResource Type="Normal" Path="fonts/font_wryh_b.ttf" Plist="" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint />
            <Position X="20.0000" Y="15.0000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.0313" Y="0.0156" />
            <PreSize X="0.3125" Y="0.0521" />
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