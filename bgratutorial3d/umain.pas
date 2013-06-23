unit umain;

{$mode objfpc}{$H+}

interface

{ This unit provides a user interface for showing the scenes, create the
  scene objects with different parameters, and handle mouse interaction. 
  
  It also show information about rendering counters and speed. 
  
  Scene 5 is handled differently in BGRASurfaceMouseMove because it is
  a first-person view, whereas in other scenes, it is the viewed object
  that gets rotated. }

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Spin, BGRAVirtualScreen, BGRAButton, BGRABitmap, BGRAScene3D, EpikTimer;

type

  { TForm1 }

  TForm1 = class(TForm)
    BGRAButton1: TBGRAButton;
    BGRAButton2: TBGRAButton;
    BGRAButton3: TBGRAButton;
    BGRAButton4: TBGRAButton;
    BGRAButton5: TBGRAButton;
    BGRAButton6: TBGRAButton;
    BGRAButton7: TBGRAButton;
    BGRAButton8: TBGRAButton;
    BGRAButton9: TBGRAButton;
    BGRASurface: TBGRAVirtualScreen;
    SpinEdit_AA: TSpinEdit;
    Timer1: TTimer;
    vsToolbar: TBGRAVirtualScreen;
    procedure BGRAButton1Click(Sender: TObject);
    procedure BGRAButton2Click(Sender: TObject);
    procedure BGRAButton3Click(Sender: TObject);
    procedure BGRAButton4Click(Sender: TObject);
    procedure BGRAButton5Click(Sender: TObject);
    procedure BGRAButton6Click(Sender: TObject);
    procedure BGRAButton7Click(Sender: TObject);
    procedure BGRAButton8Click(Sender: TObject);
    procedure BGRAButton9Click(Sender: TObject);
    procedure BGRASurfaceClick(Sender: TObject);
    procedure BGRASurfaceMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BGRASurfaceMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure BGRASurfaceMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BGRASurfaceRedraw(Sender: TObject; Bitmap: TBGRABitmap);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure SpinEdit_AAChange(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure vsToolbarRedraw(Sender: TObject; Bitmap: TBGRABitmap);
  private
    { private declarations }
  public
    { public declarations }
    inBGRASurfaceRedraw: boolean;
    scene: TBGRAScene3D;
    moving: boolean;
    moveOrigin: TPoint;
    timer: TEpikTimer;
  end; 

var
  Form1: TForm1; 

implementation

{$R *.lfm}

uses ubgrasamples, ex1, ex2, ex3, ex4, ex5, BGRABitmapTypes;

{ TForm1 }

procedure TForm1.vsToolbarRedraw(Sender: TObject; Bitmap: TBGRABitmap);
begin
  DrawWin7ToolBar(Bitmap,vsToolBar.Align);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  StyleButtonsSample(vsToolBar,ssWin7ToolBar);
  scene := nil;
  timer := TEpikTimer.Create(nil);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  timer.Free;
end;

procedure TForm1.FormKeyPress(Sender: TObject; var Key: char);
begin
  if Key = '+' then
  begin
    if scene <> nil then
    begin
      scene.Zoom := scene.Zoom*1.5;
      BGRASurface.RedrawBitmap;
      Key := #0;
    end;
  end;
  if Key = '-' then
  begin
    if scene <> nil then
    begin
      scene.Zoom := scene.Zoom*(1/1.5);
      BGRASurface.RedrawBitmap;
      Key := #0;
    end;
  end;
end;

procedure TForm1.SpinEdit_AAChange(Sender: TObject);
begin
  if not inBGRASurfaceRedraw then
  begin
    if scene <> nil then
      scene.RenderingOptions.AntialiasingResampleLevel := SpinEdit_AA.Value;
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := false;
  BGRASurface.RedrawBitmap;
end;

procedure TForm1.BGRASurfaceRedraw(Sender: TObject; Bitmap: TBGRABitmap);
var h,cury: integer;

  procedure TextLine(str: string);
  var
    c: TBGRAPixel;
  begin
    c := Bitmap.GetPixel(0,cury+h div 2);
    if GetLightness(GammaExpansion(c)) > 32768 then
      c := BGRABlack else c := BGRAWhite;
    Bitmap.TextOut(0,cury,str,c);
    cury += h;
  end;

begin
  inBGRASurfaceRedraw := true;
  if scene <> nil then
  begin
    if scene.RenderingOptions.AntialiasingResampleLevel <> SpinEdit_AA.Value then
      SpinEdit_AA.Value := scene.RenderingOptions.AntialiasingResampleLevel;

    scene.Surface := Bitmap;
    timer.Clear;
    timer.Start;
    scene.RenderingOptions.MinZ := 1;
    scene.Render;

    timer.Stop;

    Bitmap.FontFullHeight := 20;
    Bitmap.FontQuality := fqSystemClearType;
    h := Bitmap.FontFullHeight;

    cury := 0;
    TextLine(inttostr(round(timer.Elapsed*1000)) + ' ms');
    TextLine(inttostr(scene.Object3DCount) + ' object(s)');
    TextLine(inttostr(scene.VertexCount) + ' vertices');
    TextLine(inttostr(scene.FaceCount) + ' faces');
    TextLine(inttostr(scene.RenderedFaceCount) + ' rendered');
    TextLine(inttostr(scene.LightCount) + ' light(s)');
    Timer1.Enabled := true;
  end;
  inBGRASurfaceRedraw := false;
end;

procedure TForm1.BGRAButton1Click(Sender: TObject);
begin
  FreeAndNil(scene);
  scene := TExample1.Create;
  BGRASurface.DiscardBitmap;
end;

procedure TForm1.BGRAButton2Click(Sender: TObject);
begin
  FreeAndNil(scene);
  scene := TExample2.Create(e2lNone);
  BGRASurface.DiscardBitmap;
end;

procedure TForm1.BGRAButton3Click(Sender: TObject);
begin
  FreeAndNil(scene);
  scene := TExample2.Create(e2lLightness);
  BGRASurface.DiscardBitmap;
end;

procedure TForm1.BGRAButton4Click(Sender: TObject);
begin
  FreeAndNil(scene);
  scene := TExample2.Create(e2lColored);
  BGRASurface.DiscardBitmap;
end;

procedure TForm1.BGRAButton5Click(Sender: TObject);
begin
  FreeAndNil(scene);
  scene := TExample3.Create;
  scene.DefaultLightingNormal := lnFace;
  scene.RenderingOptions.AntialiasingMode := am3dMultishape;
  BGRASurface.DiscardBitmap;
end;

procedure TForm1.BGRAButton6Click(Sender: TObject);
begin
  FreeAndNil(scene);
  scene := TExample3.Create;
  scene.DefaultLightingNormal := lnFaceVertexMix;
  scene.RenderingOptions.AntialiasingMode := am3dResample;
  BGRASurface.DiscardBitmap;
end;

procedure TForm1.BGRAButton7Click(Sender: TObject);
begin
  FreeAndNil(scene);
  scene := TExample3.Create;
  scene.DefaultLightingNormal := lnVertex;
  scene.RenderingOptions.LightingInterpolation:= liAlwaysHighQuality;
  BGRASurface.DiscardBitmap;
end;

procedure TForm1.BGRAButton8Click(Sender: TObject);
begin
  FreeAndNil(scene);
  scene := TExample4.Create;
  BGRASurface.DiscardBitmap;
end;

procedure TForm1.BGRAButton9Click(Sender: TObject);
begin
  FreeAndNil(scene);
  scene := TExample5.Create;
  BGRASurface.DiscardBitmap;
end;

procedure TForm1.BGRASurfaceClick(Sender: TObject);
begin

end;

procedure TForm1.BGRASurfaceMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (button = mbLeft) and (scene <> nil) then
  begin
    moving := true;
    moveOrigin := point(x,y);
  end;
end;

procedure TForm1.BGRASurfaceMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if moving then
  begin
    if scene is TExample5 then
    begin
      scene.LookRight(X-moveOrigin.X);
      scene.LookDown(Y-moveOrigin.Y);
      BGRASurface.RedrawBitmap;
    end else
    if scene.Object3DCount > 0 then
    begin
      scene.Object3D[0].MainPart.RotateYDeg(-(X-moveOrigin.X),False);
      scene.Object3D[0].MainPart.RotateXDeg(Y-moveOrigin.Y,False);
      BGRASurface.RedrawBitmap;
    end;
    moveOrigin := point(x,y);
  end;
end;

procedure TForm1.BGRASurfaceMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if button = mbLeft then moving := false;
end;

end.

