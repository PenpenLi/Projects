<GameFile>
  <PropertyGroup Name="hit" Type="Node" ID="50213bc3-ca52-48f9-927c-7fa103ac1dd7" Version="3.10.0.0" />
  <Content ctype="GameProjectContent">
    <Content>
      <Animation Duration="28" Speed="1.0000">
        <Timeline ActionTag="427661199" Property="Position">
          <PointFrame FrameIndex="3" X="1.0500" Y="5.2517">
            <EasingData Type="0" />
          </PointFrame>
        </Timeline>
        <Timeline ActionTag="427661199" Property="Scale">
          <ScaleFrame FrameIndex="0" X="0.7059" Y="0.7059">
            <EasingData Type="0" />
          </ScaleFrame>
          <ScaleFrame FrameIndex="3" X="2.7644" Y="2.7644">
            <EasingData Type="0" />
          </ScaleFrame>
          <ScaleFrame FrameIndex="28" X="0.9580" Y="0.9580">
            <EasingData Type="0" />
          </ScaleFrame>
        </Timeline>
        <Timeline ActionTag="427661199" Property="VisibleForFrame">
          <BoolFrame FrameIndex="0" Tween="False" Value="True" />
          <BoolFrame FrameIndex="28" Tween="False" Value="False" />
        </Timeline>
        <Timeline ActionTag="-1626875263" Property="Scale">
          <ScaleFrame FrameIndex="0" X="1.0000" Y="1.0000">
            <EasingData Type="0" />
          </ScaleFrame>
          <ScaleFrame FrameIndex="3" X="4.6923" Y="4.6923">
            <EasingData Type="0" />
          </ScaleFrame>
          <ScaleFrame FrameIndex="28" X="7.1572" Y="7.1572">
            <EasingData Type="0" />
          </ScaleFrame>
        </Timeline>
        <Timeline ActionTag="-1626875263" Property="Alpha">
          <IntFrame FrameIndex="0" Value="255">
            <EasingData Type="0" />
          </IntFrame>
          <IntFrame FrameIndex="3" Value="255">
            <EasingData Type="0" />
          </IntFrame>
          <IntFrame FrameIndex="28" Value="0">
            <EasingData Type="0" />
          </IntFrame>
        </Timeline>
        <Timeline ActionTag="-1626875263" Property="Position">
          <PointFrame FrameIndex="0" X="-0.9453" Y="6.9518">
            <EasingData Type="0" />
          </PointFrame>
        </Timeline>
        <Timeline ActionTag="-1626875263" Property="RotationSkew">
          <ScaleFrame FrameIndex="0" X="0.0000" Y="0.0000">
            <EasingData Type="0" />
          </ScaleFrame>
        </Timeline>
        <Timeline ActionTag="-1626875263" Property="VisibleForFrame">
          <BoolFrame FrameIndex="0" Tween="False" Value="True" />
        </Timeline>
      </Animation>
      <ObjectData Name="Node" Tag="220" ctype="GameNodeObjectData">
        <Size X="0.0000" Y="0.0000" />
        <Children>
          <AbstractNodeData Name="Particle_9" ActionTag="427661199" Tag="38" IconVisible="True" LeftMargin="1.0500" RightMargin="-1.0500" TopMargin="-5.2517" BottomMargin="5.2517" ctype="ParticleObjectData">
            <Size X="0.0000" Y="0.0000" />
            <AnchorPoint />
            <Position X="1.0500" Y="5.2517" />
            <Scale ScaleX="0.7059" ScaleY="0.7059" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="0.0000" Y="0.0000" />
            <FileData Type="Normal" Path="particle/firehalo.plist" Plist="" />
            <BlendFunc Src="770" Dst="1" />
          </AbstractNodeData>
          <AbstractNodeData Name="halo2_1" ActionTag="-1626875263" Tag="28" IconVisible="False" LeftMargin="-78.9453" RightMargin="-77.0547" TopMargin="-84.9518" BottomMargin="-71.0482" ctype="SpriteObjectData">
            <Size X="156.0000" Y="156.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="-0.9453" Y="6.9518" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="96" />
            <PrePosition />
            <PreSize X="0.0000" Y="0.0000" />
            <FileData Type="Normal" Path="images/ui_staff/halo2.png" Plist="" />
            <BlendFunc Src="1" Dst="771" />
          </AbstractNodeData>
        </Children>
      </ObjectData>
    </Content>
  </Content>
</GameFile>