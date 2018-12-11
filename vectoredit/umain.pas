unit umain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, FileUtil, Forms, Controls, Graphics, Dialogs,
  LCLType, ExtCtrls, StdCtrls, ComCtrls, ExtDlgs, Menus, ActnList,
  uscaledpi in {$IFDEF WINDOWS}'..\lazpaint\uscaledpi.pas'{$ELSE}'../lazpaint/uscaledpi.pas'{$ENDIF},
  BCTrackbarUpdown, BCPanel, BCButton, BGRAVirtualScreen, BGRAImageList,
  BGRABitmap, BGRABitmapTypes, BGRAGraphics, BGRALazPaint, BGRALayerOriginal,
  BGRATransform, BGRAGradientScanner, LCVectorOriginal, LCVectorialFill,
  LCVectorShapes, LCVectorPolyShapes, LCVectorialFillInterface;

const
  ToolIconSize = 36;
  ActionIconSize = 24;
  EditorPointSize = 7;
  PenStyleToStr : array[TPenStyle] of string = ('─────', '─ ─ ─ ─', '···············', '─ · ─ · ─', '─ ·· ─ ·· ╴', 'InsideFrame', 'Pattern', 'Clear');
  PhongShapeKindToStr: array[TPhongShapeKind] of string = ('Rectangle', 'Round rectangle', 'Half sphere', 'Cone top', 'Cone side',
                     'Horizontal cylinder', 'Vertical cylinder');

type
  TPaintTool = (ptHand, ptMoveBackFillPoint, ptRectangle, ptEllipse, ptPolyline, ptCurve, ptPolygon, ptClosedCurve,
                ptPhongShape);

const
  PaintToolClass : array[TPaintTool] of TVectorShapeAny =
    (nil, nil, TRectShape, TEllipseShape, TPolylineShape, TCurveShape, TPolylineShape, TCurveShape,
     TPhongShape);

function IsCreateShapeTool(ATool: TPaintTool): boolean;

const
  SplineStyleToStr : array[TSplineStyle] of string =
    ('Inside','Inside + ends','Crossing','Crossing + ends','Outside','Round outside','Vertex to side','Easy Bézier');

type
  { TForm1 }

  TForm1 = class(TForm)
    ButtonMoveBackFillPoints: TToolButton;
    LBack: TLabel;
    PanelBackFillHead: TPanel;
    PanelBackFillIntf: TPanel;
    ShapeSendToBack: TAction;
    ShapeBringToFront: TAction;
    ShapeMoveDown: TAction;
    ShapeMoveUp: TAction;
    ToolBarBackFill: TToolBar;
    VectorImageList24: TBGRAImageList;
    ActionList: TActionList;
    EditCopy: TAction;
    EditCut: TAction;
    EditDelete: TAction;
    EditPaste: TAction;
    FileNew: TAction;
    FileOpen: TAction;
    FileSave: TAction;
    FileSaveAs: TAction;
    ButtonPenStyle: TBCButton;
    Label1: TLabel;
    Label3: TLabel;
    PanelBackFill: TBCPanel;
    PanelBasicStyle: TBCPanel;
    PanelExtendedStyle: TBCPanel;
    PanelFile: TBCPanel;
    PanelShape: TBCPanel;
    PhongImageList: TBGRAImageList;
    PenStyleImageList: TBGRAImageList;
    CurveImageList: TBGRAImageList;
    ShapePenColor: TShape;
    ToolBarFile: TToolBar;
    ToolBarEdit: TToolBar;
    ToolBarTop: TToolBar;
    ToolBarJoinStyle: TToolBar;
    ToolButton1: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ToolButtonJoinBevel: TToolButton;
    ToolButtonJoinMiter: TToolButton;
    ToolButtonJoinRound: TToolButton;
    ToolButtonPhongShape: TToolButton;
    BCPanelToolChoice: TBCPanel;
    BCPanelToolbar: TBCPanel;
    ToolImageList48: TBGRAImageList;
    BGRAVirtualScreen1: TBGRAVirtualScreen;
    ColorDialog1: TColorDialog;
    OpenDialog1: TOpenDialog;
    OpenPictureDialog1: TOpenPictureDialog;
    SaveDialog1: TSaveDialog;
    ToolBarTools: TToolBar;
    ToolButtonPolyline: TToolButton;
    ToolButtonCurve: TToolButton;
    ToolButtonMove: TToolButton;
    ToolButtonClosedCurve: TToolButton;
    ToolButtonPolygon: TToolButton;
    ToolButtonRectangle: TToolButton;
    ToolButtonEllipse: TToolButton;
    UpDownPenAlpha: TBCTrackbarUpdown;
    UpDownPenWidth: TBCTrackbarUpdown;
    procedure BCPanelToolbarResize(Sender: TObject);
    procedure BCPanelToolChoiceResize(Sender: TObject);
    procedure ButtonPenStyleClick(Sender: TObject);
    procedure EditCopyExecute(Sender: TObject);
    procedure EditCutExecute(Sender: TObject);
    procedure EditDeleteExecute(Sender: TObject);
    procedure EditPasteExecute(Sender: TObject);
    procedure EditPasteUpdate(Sender: TObject);
    procedure FileNewExecute(Sender: TObject);
    procedure FileOpenExecute(Sender: TObject);
    procedure FileSaveAsExecute(Sender: TObject);
    procedure FileSaveExecute(Sender: TObject);
    procedure PanelBackFillIntfResize(Sender: TObject);
    procedure PanelFileResize(Sender: TObject);
    procedure PanelShapeResize(Sender: TObject);
   procedure ShapeBringToFrontExecute(Sender: TObject);
    procedure ShapeMoveDownExecute(Sender: TObject);
    procedure ShapeMoveUpExecute(Sender: TObject);
    procedure ShapeSendToBackExecute(Sender: TObject);
    procedure ToolButtonJoinClick(Sender: TObject);
    procedure UpDownPenWidthChange(Sender: TObject; AByUser: boolean);
    procedure BGRAVirtualScreen1MouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure BGRAVirtualScreen1MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure BGRAVirtualScreen1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BGRAVirtualScreen1Redraw(Sender: TObject; Bitmap: TBGRABitmap);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; {%H-}Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormUTF8KeyPress(Sender: TObject; var UTF8Key: TUTF8Char);
    procedure ShapePenColorMouseUp(Sender: TObject; {%H-}Button: TMouseButton;
      {%H-}Shift: TShiftState; {%H-}X, {%H-}Y: Integer);
    procedure ToolButtonClick(Sender: TObject);
    procedure UpDownPenAlphaChange(Sender: TObject; AByUser: boolean);
  private
    FPenColor: TBGRAPixel;
    FPenWidth: single;
    FPenStyle: TBGRAPenStyle;
    FPenJoinStyle: TPenJoinStyle;
    FBackFillIntf: TVectorialFillInterface;
    FFlattened: TBGRABitmap;
    FLastEditorBounds: TRect;
    FUpdatingFromShape: boolean;
    FUpdatingSpinEditPenWidth: boolean;
    FCurrentTool: TPaintTool;
    FSplineStyle: TSplineStyle;
    FSplineStyleMenu: TPopupMenu;
    FComboboxSplineStyle: TBCButton;
    FSplineToolbar: TToolBar;
    FPenStyleMenu: TPopupMenu;
    FPhongShapeKind: TPhongShapeKind;
    FPhongShapeKindToolbar: TToolBar;
    FPhongShapeAltitude,FPhongBorderSize: single;
    FUpDownPhongShapeAltitude,
    FUpDownPhongBorderSize: TBCTrackbarUpdown;
    FInRemoveShapeIfEmpty: Boolean;
    procedure ComboBoxSplineStyleClick(Sender: TObject);
    function GetPenColor: TBGRAPixel;
    function GetPenStyle: TBGRAPenStyle;
    function GetPenWidth: single;
    function GetSplineStyle: TSplineStyle;
    function GetVectorTransform: TAffineMatrix;
    function GetZoomFactor: single;
    procedure ImageChange(ARectF: TRectF);
    procedure LoadVectorImages;
    procedure OnClickSplineStyleItem(ASender: TObject);
    procedure OnEditingChange({%H-}ASender: TObject; AOriginal: TBGRALayerCustomOriginal);
    procedure OnOriginalChange({%H-}ASender: TObject; AOriginal: TBGRALayerCustomOriginal);
    procedure OnPhongBorderSizeChange(Sender: TObject; AByUser: boolean);
    procedure OnPhongShapeAltitudeChange(Sender: TObject; AByUser: boolean);
    procedure OnSelectShape(ASender: TObject; AShape: TVectorShape; APreviousShape: TVectorShape);
    procedure OnClickPenStyle(ASender: TObject);
    procedure PhongShapeKindClick(Sender: TObject);
    procedure RequestBackFillUpdate(Sender: TObject);
    procedure OnBackFillChange({%H-}ASender: TObject);
    procedure SetCurrentTool(AValue: TPaintTool);
    procedure SetPenColor(AValue: TBGRAPixel);
    procedure SetPenJoinStyle(AValue: TPenJoinStyle);
    procedure SetPenStyle(AValue: TBGRAPenStyle);
    procedure SetPenWidth(AValue: single);
    procedure SetPhongShapeKind(AValue: TPhongShapeKind);
    procedure SetSplineStyle(AValue: TSplineStyle);
    procedure SplineToolbarClick(Sender: TObject);
    procedure UpdateViewCursor(ACursor: TOriginalEditorCursor);
    procedure RenderAndUpdate(ADraft: boolean);
    procedure UpdateFlattenedImage(ARect: TRect; AUpdateView: boolean = true);
    procedure UpdateView(AImageChangeRect: TRect);
    procedure UpdateToolbarFromShape(AShape: TVectorShape);
    procedure UpdateTitleBar;
    procedure ImageChangesCompletely;
    function CreateShape(const APoint1, APoint2: TPointF): TVectorShape;
    function CreateBackFill(AShape: TVectorShape): TVectorialFill;
    procedure RemoveExtendedStyleControls;
    procedure UpdateBackToolFillPoints;
    procedure UpdateShapeBackFill;
    procedure UpdateShapeUserMode;
    procedure UpdateShapeActions(AShape: TVectorShape);
    procedure RemoveShapeIfEmpty(AShape: TVectorShape);
    function VirtualScreenToImgCoord(X,Y: Integer): TPointF;
    procedure SetEditorGrid(AActive: boolean);
    procedure RequestBackFillAdjustToShape(Sender: TObject);
  public
    { public declarations }
    img: TBGRALazPaintImage;
    filename: string;
    vectorOriginal: TVectorOriginal;
    zoom: TAffineMatrix;
    newShape: TVectorShape;
    justDown: boolean;
    newStartPoint: TPointF;
    newButton: TMouseButton;
    vectorLayer: Integer;
    mouseState: TShiftState;
    baseCaption: string;
    procedure DoCopy;
    procedure DoCut;
    procedure DoPaste;
    procedure DoDelete;
    property vectorTransform: TAffineMatrix read GetVectorTransform;
    property penColor: TBGRAPixel read GetPenColor write SetPenColor;
    property penWidth: single read GetPenWidth write SetPenWidth;
    property penStyle: TBGRAPenStyle read GetPenStyle write SetPenStyle;
    property splineStyle: TSplineStyle read GetSplineStyle write SetSplineStyle;
    property currentTool: TPaintTool read FCurrentTool write SetCurrentTool;
    property joinStyle: TPenJoinStyle read FPenJoinStyle write SetPenJoinStyle;
    property phongShapeKind: TPhongShapeKind read FPhongShapeKind write SetPhongShapeKind;
    property zoomFactor: single read GetZoomFactor;
  end;

var
  Form1: TForm1;

implementation

uses math, BGRAPen, BGRAThumbnail, BGRAGradientOriginal, uvectorclipboard, LResources, LCToolbars;

{$R *.lfm}

function LCLKeyToSpecialKey(Key: Word): TSpecialKey;
var
  sk: TSpecialKey;
begin
  for sk := low(TSpecialKey) to high(TSpecialKey) do
    if Key = SpecialKeyToLCL[sk] then exit(sk);
  exit(skUnknown);
end;

function IsCreateShapeTool(ATool: TPaintTool): boolean;
begin
  result := PaintToolClass[ATool] <> nil;
end;

procedure TForm1.LoadVectorImages;
var
  vectorImageList: TBGRAImageList;
  lst: TStringList;
  i, fullIconHeight: Integer;
begin
  if VectorImageList24.Height = ActionIconSize then exit;

  vectorImageList:= TBGRAImageList.Create(self);
  vectorImageList.Width := ActionIconSize;
  vectorImageList.Height := ActionIconSize;
  lst := TStringList.Create;
  lst.CommaText := GetResourceString('vectorimages.lst');
  for i := 0 to lst.Count-1 do
    LoadToolbarImage(vectorImageList, i, lst[i]);
  lst.Free;

  SetToolbarImages(ToolBarFile, vectorImageList);
  SetToolbarImages(ToolBarEdit, vectorImageList);
  SetToolBarImages(ToolBarBackFill, vectorImageList);
  fullIconHeight := ActionIconSize+4;
  ToolbarTop.ButtonHeight:= 2*fullIconHeight+4;
  LBack.Height := fullIconHeight;
end;

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
var
  item: TMenuItem;
  ps: TPenStyle;
  ss: TSplineStyle;
  toolImageList: TBGRAImageList;
  i: Integer;
begin
  baseCaption:= Caption;
  if ToolIconSize <> ToolImageList48.Width then
  begin
    toolImageList := TBGRAImageList.Create(self);
    ScaleImageList(ToolImageList48, ToolIconSize,ToolIconSize, toolImageList);
    SetToolbarImages(ToolBarTools, toolImageList);
  end;

  LoadVectorImages;

  for i := 0 to ActionList.ActionCount-1 do
    with (ActionList.Actions[i] as TAction) do
      if Hint = '' then Hint := Caption;

  img := TBGRALazPaintImage.Create(640,480);
  filename := '';
  vectorOriginal := TVectorOriginal.Create;
  vectorLayer := img.AddLayerFromOwnedOriginal(vectorOriginal);
  img.LayerOriginalMatrix[vectorLayer] := AffineMatrixScale(1,1);
  vectorOriginal.OnSelectShape:= @OnSelectShape;
  img.OnOriginalEditingChange:= @OnEditingChange;
  img.OnOriginalChange:= @OnOriginalChange;

  zoom := AffineMatrixScale(20,20);
  FPenStyleMenu := TPopupMenu.Create(nil);
  item:= TMenuItem.Create(FPenStyleMenu); item.Caption := PenStyleToStr[psClear];
  item.OnClick := @OnClickPenStyle;       item.Tag := ord(psClear);
  FPenStyleMenu.Items.Add(item);
  for ps := psSolid to psDashDotDot do
  begin
    item:= TMenuItem.Create(FPenStyleMenu); item.Caption := PenStyleToStr[ps];
    item.OnClick := @OnClickPenStyle;       item.Tag := ord(ps);
    FPenStyleMenu.Items.Add(item);
  end;

  FBackFillIntf := TVectorialFillInterface.Create(nil, ActionIconSize,ActionIconSize);
  FBackFillIntf.SolidColor := CSSDodgerBlue;
  FBackFillIntf.OnFillChange:=@RequestBackFillUpdate;
  FBackFillIntf.OnAdjustToShape:=@RequestBackFillAdjustToShape;
  FBackFillIntf.Container := PanelBackFillIntf;

  FSplineStyleMenu := TPopupMenu.Create(nil);
  for ss := low(TSplineStyle) to high(TSplineStyle) do
  begin
    item := TMenuItem.Create(FSplineStyleMenu); item.Caption := SplineStyleToStr[ss];
    item.OnClick:=@OnClickSplineStyleItem;
        item.Tag := ord(ss);
    FSplineStyleMenu.Items.Add(item);
  end;

  newShape:= nil;
  penColor := BGRABlack;
  penWidth := 5;
  penStyle := SolidPenStyle;
  joinStyle:= pjsBevel;
  currentTool:= ptHand;
  splineStyle:= ssEasyBezier;
  FPhongShapeAltitude := DefaultPhongShapeAltitudePercent;
  FPhongBorderSize := DefaultPhongBorderSizePercent;
  UpdateTitleBar;
  UpdateBackToolFillPoints;
  UpdateShapeActions(nil);
end;

procedure TForm1.BGRAVirtualScreen1Redraw(Sender: TObject; Bitmap: TBGRABitmap);
var
  topLeftF, bottomRightF: TPointF;
  zoomBounds: TRect;
begin
  topLeftF := zoom*PointF(0,0);
  bottomRightF := zoom*PointF(img.Width,img.Height);
  zoomBounds := Rect(round(topLeftF.X),round(topLeftF.Y),round(bottomRightF.X),round(bottomRightF.Y));
  Bitmap.DrawCheckers(zoomBounds, CSSWhite,CSSSilver);
  if FFlattened = nil then
    UpdateFlattenedImage(rect(0,0,img.Width,img.Height), false);
  Bitmap.StretchPutImage(zoomBounds, FFlattened, dmLinearBlend);
  FLastEditorBounds := img.DrawEditor(Bitmap, vectorLayer, zoom, EditorPointSize);
end;

procedure TForm1.BGRAVirtualScreen1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  imgPtF: TPointF;
  cur: TOriginalEditorCursor;
  handled: boolean;
begin
  mouseState:= Shift;
  imgPtF := VirtualScreenToImgCoord(X,Y);
  SetEditorGrid(ssCtrl in Shift);
  img.MouseDown(Button=mbRight, Shift, imgPtF.x, imgPtF.y, cur, handled);
  UpdateViewCursor(cur);
  if handled then exit;

  if not justDown and not Assigned(newShape) then
  begin
    newStartPoint := AffineMatrixInverse(AffineMatrixTranslation(-0.5,-0.5)*vectorTransform*AffineMatrixTranslation(0.5,0.5))*imgPtF;
    newButton := Button;
    justDown := true;
  end;
end;

procedure TForm1.UpDownPenWidthChange(Sender: TObject; AByUser: boolean);
begin
  if FUpdatingSpinEditPenWidth or not AByUser then exit;
  penWidth := UpDownPenWidth.Value*0.1;
end;

procedure TForm1.ShapeBringToFrontExecute(Sender: TObject);
begin
  if Assigned(vectorOriginal) and
     Assigned(vectorOriginal.SelectedShape) then
  begin
    vectorOriginal.SelectedShape.BringToFront;
    UpdateShapeActions(vectorOriginal.SelectedShape);
  end;
end;

procedure TForm1.ShapeMoveDownExecute(Sender: TObject);
begin
  if Assigned(vectorOriginal) and
     Assigned(vectorOriginal.SelectedShape) then
  begin
    vectorOriginal.SelectedShape.MoveDown(true);
    UpdateShapeActions(vectorOriginal.SelectedShape);
  end;
end;

procedure TForm1.ShapeMoveUpExecute(Sender: TObject);
begin
  if Assigned(vectorOriginal) and
     Assigned(vectorOriginal.SelectedShape) then
  begin
    vectorOriginal.SelectedShape.MoveUp(true);
    UpdateShapeActions(vectorOriginal.SelectedShape);
  end;
end;

procedure TForm1.ShapeSendToBackExecute(Sender: TObject);
begin
  if Assigned(vectorOriginal) and
     Assigned(vectorOriginal.SelectedShape) then
  begin
    vectorOriginal.SelectedShape.SendToBack;
    UpdateShapeActions(vectorOriginal.SelectedShape);
  end;
end;

procedure TForm1.ToolButtonJoinClick(Sender: TObject);
begin
  if (Sender as TToolButton).Down then
  begin
    if Sender = ToolButtonJoinRound then joinStyle := pjsRound else
    if Sender = ToolButtonJoinBevel then joinStyle := pjsBevel else
    if Sender = ToolButtonJoinMiter then joinStyle := pjsMiter;
  end;
end;

procedure TForm1.EditCopyExecute(Sender: TObject);
begin
  DoCopy;
end;

procedure TForm1.EditCutExecute(Sender: TObject);
begin
  DoCut;
end;

procedure TForm1.EditDeleteExecute(Sender: TObject);
begin
  DoDelete;
end;

procedure TForm1.EditPasteExecute(Sender: TObject);
begin
  DoPaste;
end;

procedure TForm1.EditPasteUpdate(Sender: TObject);
begin
  EditPaste.Enabled := ClipboardHasShapes;
end;

procedure TForm1.FileNewExecute(Sender: TObject);
begin
  if Assigned(vectorOriginal) then
  begin
    vectorOriginal.Clear;
    filename := '';
    UpdateTitleBar;
  end;
end;

procedure TForm1.FileOpenExecute(Sender: TObject);
var
  openedImg: TBGRALazPaintImage;
  openedLayer: Integer;
  openedLayerOriginal: TBGRALayerCustomOriginal;
begin
  if OpenDialog1.Execute then
  begin
    openedImg := TBGRALazPaintImage.Create;
    try
      openedImg.LoadFromFile(OpenDialog1.FileName);
      if openedImg.NbLayers <> 1 then raise exception.Create('Expecting one layer only');
      openedLayer := 0;
      openedLayerOriginal := openedImg.LayerOriginal[openedLayer];
      if (openedLayerOriginal = nil) or not (openedLayerOriginal is TVectorOriginal) then
        raise exception.Create('Not a vectorial image');

      img.Free;
      img := openedImg;
      openedImg := nil;
      vectorLayer:= openedLayer;
      vectorOriginal := TVectorOriginal(openedLayerOriginal);
      vectorOriginal.OnSelectShape:= @OnSelectShape;
      img.OnOriginalEditingChange:= @OnEditingChange;
      img.OnOriginalChange:= @OnOriginalChange;
      filename:= OpenDialog1.FileName;
      UpdateTitleBar;
      ImageChangesCompletely;
    except
      on ex: exception do
        ShowMessage(ex.Message);
    end;
    openedImg.Free;
  end;
end;

procedure TForm1.FileSaveAsExecute(Sender: TObject);
begin
  if not Assigned(img) then exit;
  if SaveDialog1.Execute then
  begin
    try
      if Assigned(vectorOriginal) then RemoveShapeIfEmpty(vectorOriginal.SelectedShape);
      img.SaveToFile(SaveDialog1.FileName);
      filename := SaveDialog1.FileName;
      UpdateTitleBar;
    except
      on ex: exception do
        ShowMessage(ex.Message);
    end;
  end;
end;

procedure TForm1.FileSaveExecute(Sender: TObject);
begin
  if filename = '' then
    FileSaveAs.Execute
  else
  begin
    try
      if Assigned(vectorOriginal) then RemoveShapeIfEmpty(vectorOriginal.SelectedShape);
      img.SaveToFile(filename);
    except
      on ex: exception do
        ShowMessage(ex.Message);
    end;
  end;
end;

procedure TForm1.PanelBackFillIntfResize(Sender: TObject);
begin
  with FBackFillIntf.PreferredSize do
  begin
    PanelBackFillIntf.Width := cx;
    PanelBackFillIntf.Height := cy;
  end;
  PanelBackFill.Width := PanelBackFillIntf.Left+PanelBackFillIntf.Width+1;
end;

procedure TForm1.PanelFileResize(Sender: TObject);
begin
  ToolBarFile.Width := GetToolbarSize(ToolBarFile).cx;
  PanelFile.Width := ToolBarFile.Width+3;
end;

procedure TForm1.PanelShapeResize(Sender: TObject);
begin
  ToolBarEdit.Width := GetToolbarSize(ToolBarEdit).cx;
  PanelShape.Width := ToolBarEdit.Width+3;
end;

procedure TForm1.ButtonPenStyleClick(Sender: TObject);
begin
  if Assigned(FPenStyleMenu) then
    with ButtonPenStyle.ClientToScreen(Point(0,ButtonPenStyle.Height)) do
      FPenStyleMenu.PopUp(X,Y);
end;

procedure TForm1.BCPanelToolChoiceResize(Sender: TObject);
begin
  ToolbarTools.Width := GetToolbarSize(ToolbarTools).cx;
  BCPanelToolChoice.Width := ToolbarTools.Width+3;
end;

procedure TForm1.BCPanelToolbarResize(Sender: TObject);
begin
  ToolBarTop.Height := GetToolbarSize(ToolBarTop,0).cy;
  BCPanelToolbar.Height := ToolBarTop.Height;
end;

procedure TForm1.BGRAVirtualScreen1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  imgPtF, ptF: TPointF;
  prevRF, rF: TRectF;
  cur: TOriginalEditorCursor;
  handled: boolean;
  vectorFill: TVectorialFill;
begin
  mouseState:= Shift;
  imgPtF := VirtualScreenToImgCoord(X,Y);
  SetEditorGrid(ssCtrl in Shift);
  img.MouseMove(Shift, imgPtF.X, imgPtF.Y, cur, handled);
  UpdateViewCursor(cur);

  ptF := AffineMatrixInverse(AffineMatrixTranslation(-0.5,-0.5)*vectorTransform*AffineMatrixTranslation(0.5,0.5))*imgPtF;
  if justDown and not Assigned(newShape) and IsCreateShapeTool(currentTool) and
    (VectLen(ptF-newStartPoint) >= EditorPointSize) then
  begin
    vectorOriginal.DeselectShape;
    newShape := CreateShape(newStartPoint,ptF);
    rF := newShape.GetRenderBounds(InfiniteRect, vectorTransform);
    ImageChange(rF);
    justDown := false;
  end else
  if Assigned(newShape) then
  begin
    prevRF := newShape.GetRenderBounds(InfiniteRect, vectorTransform);
    newShape.QuickDefine(newStartPoint,ptF);
    if (vsfBackFill in newShape.Fields) and (newShape.BackFill.FillType in [vftGradient, vftTexture]) then
    begin
      vectorFill := CreateBackFill(newShape);
      newShape.BackFill := vectorFill;
      vectorFill.Free;
    end;
    rF := newShape.GetRenderBounds(InfiniteRect, vectorTransform);
    ImageChange(rF.Union(prevRF, true));
  end;
end;

procedure TForm1.BGRAVirtualScreen1MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  rF: TRectF;
  imgPtF: TPointF;
  handled: boolean;
  cur: TOriginalEditorCursor;
  addedShape: TVectorShape;
begin
  mouseState:= Shift;
  imgPtF := VirtualScreenToImgCoord(X,Y);
  SetEditorGrid(ssCtrl in Shift);
  img.MouseUp(Button = mbRight, Shift, imgPtF.X, imgPtF.Y, cur, handled);
  if handled then RenderAndUpdate(false);
  UpdateViewCursor(cur);

  if justDown and (Button = newButton) then
  begin
    if IsCreateShapeTool(currentTool) and (vsuCreate in PaintToolClass[currentTool].Usermodes) then
    begin
      vectorOriginal.AddShape(CreateShape(newStartPoint,newStartPoint), vsuCreate);
    end else
      vectorOriginal.MouseClick(newStartPoint);
    justDown:= false;
  end
  else if Assigned(newShape) and (Button = newButton) then
  begin
    rF := newShape.GetRenderBounds(InfiniteRect, vectorTransform);
    if not IsEmptyRectF(rF) or (vsuCreate in newShape.Usermodes) then
    begin
      addedShape := newShape;
      newShape := nil;
      vectorOriginal.AddShape(addedShape, vsuCreate);
    end
    else
    begin
      FreeAndNil(newShape);
      ShowMessage('Shape is empty and was not added');
    end;
  end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  RemoveExtendedStyleControls;
  FBackFillIntf.Free;
  img.Free;
  FFlattened.Free;
  FPenStyleMenu.Free;
  FSplineStyleMenu.Free;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  AHandled: boolean;
begin
  if Assigned(img) then
  begin
    img.KeyDown(Shift, LCLKeyToSpecialKey(Key), AHandled);
    if AHandled then Key := 0;
  end;

  if (Key = VK_X) and (ssCtrl in Shift) then
  begin
    Key := 0;
    DoCut;
  end else
  if (Key = VK_C) and (ssCtrl in Shift) then
  begin
    Key := 0;
    DoCopy;
  end else
  if (Key = VK_V) and (ssCtrl in Shift) then
  begin
    Key := 0;
    DoPaste;
  end else
  if Key = VK_DELETE then
  begin
    Key := 0;
    DoDelete;
  end;
end;

procedure TForm1.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  AHandled: boolean;
begin
  if Assigned(img) then
  begin
    img.KeyUp(Shift, LCLKeyToSpecialKey(Key), AHandled);
    if AHandled then Key:= 0;
  end;
end;

procedure TForm1.FormUTF8KeyPress(Sender: TObject; var UTF8Key: TUTF8Char);
var AHandled: boolean;
begin
  if Assigned(img) then
  begin
    img.KeyPress(UTF8Key, AHandled);
    if AHandled then UTF8Key:= '';
  end;
end;

procedure TForm1.ShapePenColorMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ColorDialog1.Color := ShapePenColor.Brush.Color;
  if ColorDialog1.Execute then
  begin
    if penColor.alpha <> 0 then
      penColor := ColorToBGRA(ColorDialog1.Color, penColor.alpha)
    else
      penColor := ColorDialog1.Color;
  end;
end;

procedure TForm1.ToolButtonClick(Sender: TObject);
begin
  if Sender = ButtonMoveBackFillPoints then
    if ButtonMoveBackFillPoints.Down then ToolButtonMove.Down := true;

  FCurrentTool := ptHand;
  if ButtonMoveBackFillPoints.Down then FCurrentTool:= ptMoveBackFillPoint;
  if ToolButtonEllipse.Down then FCurrentTool:= ptEllipse;
  if ToolButtonRectangle.Down then FCurrentTool:= ptRectangle;
  if ToolButtonPolyline.Down then FCurrentTool:= ptPolyline;
  if ToolButtonCurve.Down then FCurrentTool:= ptCurve;
  if ToolButtonPolygon.Down then FCurrentTool:= ptPolygon;
  if ToolButtonClosedCurve.Down then FCurrentTool:= ptClosedCurve;
  if ToolButtonPhongShape.Down then FCurrentTool:= ptPhongShape;

  if currentTool <> ptMoveBackFillPoint then
    ButtonMoveBackFillPoints.Down := false;

  if IsCreateShapeTool(currentTool) then
  begin
    if Assigned(vectorOriginal) and (vectorOriginal.SelectedShape <> nil) then vectorOriginal.DeselectShape
    else UpdateToolbarFromShape(nil);

    if currentTool in [ptPolyline, ptCurve] then
      FBackFillIntf.FillType := vftNone;
  end;

  UpdateShapeUserMode;

  if not Assigned(vectorOriginal) or (vectorOriginal.SelectedShape = nil) then
    UpdateToolbarFromShape(nil);
end;

procedure TForm1.UpDownPenAlphaChange(Sender: TObject; AByUser: boolean);
begin
  if AByUser then
  begin
    FPenColor:= ColorToBGRA(ShapePenColor.Brush.Color, UpDownPenAlpha.Value);
    if Assigned(vectorOriginal) and Assigned(vectorOriginal.SelectedShape) then
      vectorOriginal.SelectedShape.PenColor:= FPenColor;
  end;
end;

procedure TForm1.ComboBoxSplineStyleClick(Sender: TObject);
begin
  if Assigned(FSplineStyleMenu) then
    with FComboboxSplineStyle.ClientToScreen(Point(0,FComboboxSplineStyle.Height)) do
      FSplineStyleMenu.PopUp(X,Y);
end;

function TForm1.GetPenColor: TBGRAPixel;
begin
  result := FPenColor;
end;

function TForm1.GetPenStyle: TBGRAPenStyle;
begin
  result := FPenStyle;
end;

function TForm1.GetPenWidth: single;
begin
  result := FPenWidth;
end;

function TForm1.GetSplineStyle: TSplineStyle;
begin
  result := FSplineStyle;
end;

function TForm1.GetVectorTransform: TAffineMatrix;
begin
  if vectorLayer<>-1 then
    result:= img.LayerOriginalMatrix[vectorLayer]
  else
    result:= AffineMatrixIdentity;
end;

function TForm1.GetZoomFactor: single;
begin
  result := (VectLen(PointF(zoom[1,1],zoom[2,1]))+VectLen(PointF(zoom[1,2],zoom[2,2])))/2;
end;

procedure TForm1.ImageChange(ARectF: TRectF);
var
  changeRect: TRect;
begin
  if not IsEmptyRectF(ARectF) then
  begin
    changeRect := rect(floor(ARectF.Left),floor(ARectF.Top),ceil(ARectF.Right),ceil(ARectF.Bottom));
    UpdateFlattenedImage(changeRect);
  end;
end;

procedure TForm1.OnClickSplineStyleItem(ASender: TObject);
begin
  splineStyle := TSplineStyle((ASender as TMenuItem).Tag);
end;

procedure TForm1.OnEditingChange(ASender: TObject;
  AOriginal: TBGRALayerCustomOriginal);
begin
  if AOriginal <> vectorOriginal then exit;
  UpdateView(EmptyRect);
end;

procedure TForm1.OnOriginalChange(ASender: TObject; AOriginal: TBGRALayerCustomOriginal);
var
  slowShape: boolean;
begin
  if AOriginal <> vectorOriginal then exit;
  slowShape := false;
  if mouseState * [ssLeft,ssRight] <> [] then
  begin
    if Assigned(vectorOriginal) and Assigned(vectorOriginal.SelectedShape) then
      slowShape := vectorOriginal.SelectedShape.GetIsSlow(vectorTransform);
  end;
  RenderAndUpdate(slowShape);
end;

procedure TForm1.OnPhongBorderSizeChange(Sender: TObject; AByUser: boolean);
begin
  FPhongBorderSize:= FUpDownPhongBorderSize.Value;
  if AByUser and Assigned(vectorOriginal) and Assigned(vectorOriginal.SelectedShape) and
    (vectorOriginal.SelectedShape is TPhongShape) then
    TPhongShape(vectorOriginal.SelectedShape).BorderSizePercent:= FPhongBorderSize;
end;

procedure TForm1.OnPhongShapeAltitudeChange(Sender: TObject; AByUser: boolean);
begin
  FPhongShapeAltitude:= FUpDownPhongShapeAltitude.Value;
  if AByUser and Assigned(vectorOriginal) and Assigned(vectorOriginal.SelectedShape) and
    (vectorOriginal.SelectedShape is TPhongShape) then
    TPhongShape(vectorOriginal.SelectedShape).ShapeAltitudePercent:= FPhongShapeAltitude;
end;

procedure TForm1.OnSelectShape(ASender: TObject; AShape: TVectorShape;
  APreviousShape: TVectorShape);
begin
  if ASender <> vectorOriginal then exit;
  UpdateToolbarFromShape(AShape);
  if currentTool = ptMoveBackFillPoint then
  begin
    if Assigned(AShape) and (vsuEditBackFill in AShape.Usermodes) and
       AShape.BackFill.IsEditable then
      AShape.Usermode:= vsuEditBackFill
    else
      currentTool:= ptHand;
  end;

  UpdateShapeActions(AShape);
  RemoveShapeIfEmpty(APreviousShape);
end;

procedure TForm1.OnClickPenStyle(ASender: TObject);
begin
  Case TPenStyle((ASender as TMenuItem).Tag) of
  psSolid: penStyle := SolidPenStyle;
  psDash: penStyle := DashPenStyle;
  psDot: penStyle := DotPenStyle;
  psDashDot: penStyle := DashDotPenStyle;
  psDashDotDot: penStyle := DashDotDotPenStyle;
  else penStyle := ClearPenStyle;
  end;
end;

procedure TForm1.PhongShapeKindClick(Sender: TObject);
begin
  if (Sender as TToolButton).Down then
    phongShapeKind:= TPhongShapeKind((Sender as TToolButton).Tag);
end;

procedure TForm1.RequestBackFillUpdate(Sender: TObject);
begin
  if not FUpdatingFromShape then
  begin
    UpdateShapeBackFill;
    UpdateBackToolFillPoints;
  end;
end;

procedure TForm1.OnBackFillChange(ASender: TObject);
begin
  if not FUpdatingFromShape then
    UpdateShapeBackFill;
end;

procedure TForm1.SetCurrentTool(AValue: TPaintTool);
begin
  FCurrentTool:=AValue;
  ToolButtonMove.Down := FCurrentTool = ptHand;
  ToolButtonRectangle.Down := FCurrentTool = ptRectangle;
  ToolButtonEllipse.Down := FCurrentTool = ptEllipse;
  ToolButtonPolygon.Down := FCurrentTool = ptPolygon;
  ToolButtonClosedCurve.Down := FCurrentTool = ptClosedCurve;
  ToolButtonPolyline.Down := FCurrentTool = ptPolyline;
  ToolButtonCurve.Down := FCurrentTool = ptCurve;
  ToolButtonPhongShape.Down:= FCurrentTool = ptPhongShape;
  ButtonMoveBackFillPoints.Down := FCurrentTool = ptMoveBackFillPoint;
  UpdateShapeUserMode;
end;

procedure TForm1.SetPenColor(AValue: TBGRAPixel);
begin
  FPenColor := AValue;
  ShapePenColor.Brush.Color := BGRA(AValue.red,AValue.green,AValue.blue).ToColor;
  UpDownPenAlpha.Value := AValue.alpha;
  if not FUpdatingFromShape and Assigned(vectorOriginal) then
  begin
    if Assigned(vectorOriginal.SelectedShape) then
      vectorOriginal.SelectedShape.PenColor := AValue;
  end;
end;

procedure TForm1.SetPenJoinStyle(AValue: TPenJoinStyle);
begin
  if FPenJoinStyle=AValue then Exit;
  FPenJoinStyle:=AValue;
  ToolButtonJoinRound.Down:= FPenJoinStyle = pjsRound;
  ToolButtonJoinBevel.Down:= FPenJoinStyle = pjsBevel;
  ToolButtonJoinMiter.Down:= FPenJoinStyle = pjsMiter;
  if not FUpdatingFromShape and Assigned(vectorOriginal) then
  begin
    if Assigned(vectorOriginal.SelectedShape) then
      vectorOriginal.SelectedShape.JoinStyle := FPenJoinStyle;
  end;
end;

procedure TForm1.SetPenStyle(AValue: TBGRAPenStyle);
begin
  FPenStyle := AValue;
  ButtonPenStyle.Caption:= PenStyleToStr[BGRAToPenStyle(AValue)];
  if not FUpdatingFromShape and Assigned(vectorOriginal) and Assigned(vectorOriginal.SelectedShape) then
    vectorOriginal.SelectedShape.PenStyle := FPenStyle;
end;

procedure TForm1.SetPenWidth(AValue: single);
var
  cur: single;
begin
  FPenWidth := AValue;
  cur := UpDownPenWidth.Value*0.1;
  if AValue <> cur then
  begin
    FUpdatingSpinEditPenWidth:= true;
    UpDownPenWidth.Value := Round(AValue*10);
    FUpdatingSpinEditPenWidth:= false;
  end;
  if not FUpdatingFromShape and Assigned(vectorOriginal) and Assigned(vectorOriginal.SelectedShape) then
    vectorOriginal.SelectedShape.PenWidth:= penWidth;
end;

procedure TForm1.SetPhongShapeKind(AValue: TPhongShapeKind);
var
  btn: TToolButton;
  i: Integer;
begin
  if FPhongShapeKind=AValue then Exit;
  FPhongShapeKind:=AValue;
  if Assigned(FPhongShapeKindToolbar) then
    for i := 0 to FPhongShapeKindToolbar.ButtonCount-1 do
    begin
      btn := FPhongShapeKindToolbar.Buttons[i];
      if btn.Tag = ord(FPhongShapeKind) then btn.Down := true;
    end;
  if Assigned(FUpDownPhongBorderSize) then
    FUpDownPhongBorderSize.Enabled:= (FPhongShapeKind in[pskRectangle,pskRoundRectangle]);

  if not FUpdatingFromShape and Assigned(vectorOriginal) and Assigned(vectorOriginal.SelectedShape) then
  begin
    if vectorOriginal.SelectedShape is TPhongShape then
      TPhongShape(vectorOriginal.SelectedShape).ShapeKind:= FPhongShapeKind;
  end;
end;

procedure TForm1.SetSplineStyle(AValue: TSplineStyle);
begin
  FSplineStyle := AValue;
  if Assigned(FComboboxSplineStyle) then
    FComboboxSplineStyle.Caption:= SplineStyleToStr[FSplineStyle];
  if not FUpdatingFromShape and Assigned(vectorOriginal) and Assigned(vectorOriginal.SelectedShape) and
    (vectorOriginal.SelectedShape is TCurveShape) then
    TCurveShape(vectorOriginal.SelectedShape).SplineStyle := FSplineStyle;
end;

procedure TForm1.SplineToolbarClick(Sender: TObject);
var
  btn: TToolButton;
  mode: TVectorShapeUsermode;
begin
  if Assigned(vectorOriginal) and Assigned(vectorOriginal.SelectedShape) and
     (vectorOriginal.SelectedShape is TCurveShape) then
  begin
    btn := Sender as TToolButton;
    if btn.Down then
    begin
      if btn.ImageIndex = 0 then mode := vsuEdit
      else if btn.ImageIndex = 1 then mode := vsuCurveSetAuto
      else if btn.ImageIndex = 2 then mode := vsuCurveSetCurve
      else if btn.ImageIndex = 3 then mode := vsuCurveSetAngle;
      vectorOriginal.SelectedShape.Usermode := mode;
    end;
  end;
end;

procedure TForm1.UpdateViewCursor(ACursor: TOriginalEditorCursor);
begin
  case ACursor of
    oecDefault: BGRAVirtualScreen1.Cursor := crDefault;
    oecMove: BGRAVirtualScreen1.Cursor := crSizeAll;
    oecMoveN: BGRAVirtualScreen1.Cursor := crSizeN;
    oecMoveS: BGRAVirtualScreen1.Cursor := crSizeS;
    oecMoveE: BGRAVirtualScreen1.Cursor := crSizeE;
    oecMoveW: BGRAVirtualScreen1.Cursor := crSizeW;
    oecMoveNE: BGRAVirtualScreen1.Cursor := crSizeNE;
    oecMoveSW: BGRAVirtualScreen1.Cursor := crSizeSW;
    oecMoveNW: BGRAVirtualScreen1.Cursor := crSizeNW;
    oecMoveSE: BGRAVirtualScreen1.Cursor := crSizeSE;
    oecHandPoint: BGRAVirtualScreen1.Cursor := crHandPoint;
  end;
end;

procedure TForm1.RenderAndUpdate(ADraft: boolean);
var
  renderedRect: TRect;
begin
  renderedRect := img.RenderOriginalsIfNecessary(ADraft);
  UpdateFlattenedImage(renderedRect);
end;

procedure TForm1.UpdateFlattenedImage(ARect: TRect; AUpdateView: boolean);
var
  shapeRectF: TRectF;
  shapeRect: TRect;
begin
  if FFlattened = nil then
    FFlattened := img.ComputeFlatImage
  else
  if not IsRectEmpty(ARect) then
  begin
    FFlattened.FillRect(ARect,BGRAPixelTransparent,dmSet);
    FFlattened.ClipRect := ARect;
    img.Draw(FFlattened, 0,0);
    FFlattened.NoClip;
  end;

  if Assigned(newShape) and not IsRectEmpty(ARect) then
  begin
    shapeRectF := newShape.GetRenderBounds(InfiniteRect, vectorTransform);
    with shapeRectF do
      shapeRect := rect(floor(Left),floor(Top),ceil(Right),ceil(Bottom));
    if IntersectRect(shapeRect, shapeRect, ARect) then
    begin
      FFlattened.ClipRect := shapeRect;
      newShape.Render(FFlattened, vectorTransform, newShape.GetIsSlow(vectorTransform));
      FFlattened.NoClip;
    end;
  end;

  if AUpdateView then
    UpdateView(ARect);
end;

procedure TForm1.UpdateView(AImageChangeRect: TRect);
var
  viewRectF: TRectF;
  viewRect, newEditorBounds: TRect;
begin
  if IsRectEmpty(AImageChangeRect) then
  begin
    viewRectF := EmptyRectF;
    viewRect := EmptyRect;
  end
  else
  begin
    with AImageChangeRect do
      viewRectF := RectF(zoom* PointF(Left,Top), zoom* PointF(Right,Bottom));
    viewRect := rect(floor(viewRectF.Left),floor(viewRectF.Top),ceil(viewRectF.Right),ceil(viewRectF.Bottom));
  end;

  if not IsRectEmpty(FLastEditorBounds) then
  begin
    if IsRectEmpty(viewRect) then viewRect := FLastEditorBounds else
      UnionRect(viewRect,viewRect,FLastEditorBounds);
  end;
  if Assigned(img) then
  begin
    newEditorBounds := img.GetEditorBounds(vectorLayer, zoom, EditorPointSize);
    if not IsRectEmpty(newEditorBounds) then
    begin
      if IsRectEmpty(viewRect) then viewRect := newEditorBounds else
        UnionRect(viewRect,viewRect,newEditorBounds);
    end;
  end;

  if not IsRectEmpty(viewRect) then
  begin
    viewRect.Inflate(1,1);
    BGRAVirtualScreen1.RedrawBitmap(viewRect);
  end;
end;

procedure TForm1.UpdateToolbarFromShape(AShape: TVectorShape);
const ControlMargin = 6;
var
  f: TVectorShapeFields;
  showSplineStyle, showPhongStyle: boolean;
  nextControlPos: TPoint;
  texSource: TBGRABitmap;
  mode: TVectorShapeUsermode;
  sk: TPhongShapeKind;
begin
  RemoveExtendedStyleControls;

  if AShape <> nil then
  begin
    FUpdatingFromShape := true;
    mode := AShape.Usermode;
    f := AShape.Fields;
    if vsfPenColor in f then penColor := AShape.PenColor;
    if vsfPenWidth in f then penWidth:= AShape.PenWidth;
    if vsfPenStyle in f then penStyle:= AShape.PenStyle;
    if vsfJoinStyle in f then joinStyle:= AShape.JoinStyle;

    if vsfBackFill in f then
    begin
      FBackFillIntf.FillType := AShape.BackFill.FillType;
      case FBackFillIntf.FillType of
        vftTexture:
          begin
            texSource := AShape.BackFill.Texture;
            if Assigned(texSource) then FBackFillIntf.Texture := texSource;
            FBackFillIntf.TextureOpacity:= AShape.BackFill.TextureOpacity;
            FBackFillIntf.TextureRepetition:= AShape.BackFill.TextureRepetition;
          end;
        vftSolid: FBackFillIntf.SolidColor := AShape.BackFill.SolidColor;
        vftGradient:
          begin
            FBackFillIntf.GradStartColor := AShape.BackFill.Gradient.StartColor;
            FBackFillIntf.GradEndColor := AShape.BackFill.Gradient.EndColor;
            FBackFillIntf.GradientType:= AShape.BackFill.Gradient.GradientType;
            FBackFillIntf.GradRepetition:= AShape.BackFill.Gradient.Repetition;
            FBackFillIntf.GradInterpolation := AShape.BackFill.Gradient.ColorInterpolation;
          end;
      end;
    end;

    if AShape is TCurveShape then
    begin
      showSplineStyle:= true;
      splineStyle:= TCurveShape(AShape).SplineStyle;
    end else
      showSplineStyle:= false;

    if AShape is TPhongShape then
    begin
      showPhongStyle := true;
      phongShapeKind:= TPhongShape(AShape).ShapeKind;
      FPhongShapeAltitude:= TPhongShape(AShape).ShapeAltitudePercent;
      FPhongBorderSize:= TPhongShape(AShape).BorderSizePercent;
    end else
      showPhongStyle := false;

    FUpdatingFromShape := false;
  end else
  begin
    mode := vsuEdit;
    if IsCreateShapeTool(currentTool) then
    begin
      f := PaintToolClass[currentTool].Fields;
      showSplineStyle:= PaintToolClass[currentTool] = TCurveShape;
      showPhongStyle := PaintToolClass[currentTool] = TPhongShape;
    end
    else
    begin
      f := [];
      showSplineStyle:= false;
      showPhongStyle:= false;
    end;
  end;
  UpdateBackToolFillPoints;
  UpDownPenWidth.Enabled := vsfPenWidth in f;
  ButtonPenStyle.Enabled:= vsfPenStyle in f;
  EnableDisableToolButtons([ToolButtonJoinRound,ToolButtonJoinBevel,ToolButtonJoinMiter], vsfJoinStyle in f);

  PanelExtendedStyle.Visible := false;
  nextControlPos := Point(ControlMargin,4);
  if showSplineStyle then
  begin
    PanelExtendedStyle.Visible := true;

    FSplineToolbar := CreateToolBar(CurveImageList);
    FSplineToolbar.Left := nextControlPos.X;
    FSplineToolbar.Top := nextControlPos.Y;
    FSplineToolbar.Width := 120;
    AddToolbarCheckButton(FSplineToolbar, 'Move spline points', 0, @SplineToolbarClick, mode in [vsuEdit, vsuCreate]);
    AddToolbarCheckButton(FSplineToolbar, 'Set to autodetect angle (A)', 1, @SplineToolbarClick, mode = vsuCurveSetAuto);
    AddToolbarCheckButton(FSplineToolbar, 'Set to curve (S)', 2, @SplineToolbarClick, mode = vsuCurveSetCurve);
    AddToolbarCheckButton(FSplineToolbar, 'Set to angle (X)', 3, @SplineToolbarClick, mode = vsuCurveSetAngle);
    PanelExtendedStyle.InsertControl(FSplineToolbar);

    FComboboxSplineStyle := TBCButton.Create(nil);
    FComboboxSplineStyle.Style := bbtButton;
    FComboboxSplineStyle.Left := nextControlPos.X;
    FComboboxSplineStyle.Top := nextControlPos.Y + FSplineToolbar.Height;
    FComboboxSplineStyle.Caption:= SplineStyleToStr[splineStyle];
    FComboboxSplineStyle.Width := 120;
    FComboboxSplineStyle.Height := ButtonPenStyle.Height;
    FComboboxSplineStyle.OnClick:=@ComboBoxSplineStyleClick;
    FComboboxSplineStyle.StateNormal.Assign(ButtonPenStyle.StateNormal);
    FComboboxSplineStyle.StateHover.Assign(ButtonPenStyle.StateHover);
    FComboboxSplineStyle.StateClicked.Assign(ButtonPenStyle.StateClicked);
    FComboboxSplineStyle.Rounding.Assign(ButtonPenStyle.Rounding);
    PanelExtendedStyle.InsertControl(FComboboxSplineStyle);

    nextControlPos.X := FComboboxSplineStyle.Left + FComboboxSplineStyle.Width + ControlMargin;
  end;
  if showPhongStyle then
  begin
    PanelExtendedStyle.Visible := true;

    FPhongShapeKindToolbar := CreateToolBar(PhongImageList);
    FPhongShapeKindToolbar.Left := nextControlPos.X;
    FPhongShapeKindToolbar.Top := nextControlPos.Y;
    FPhongShapeKindToolbar.Width := 120;
    for sk := low(TPhongShapeKind) to high(TPhongShapeKind) do
      AddToolbarCheckButton(FPhongShapeKindToolbar, PhongShapeKindToStr[sk], ord(sk), @PhongShapeKindClick, FPhongShapeKind = sk, true, ord(sk));
    PanelExtendedStyle.InsertControl(FPhongShapeKindToolbar);

    FUpDownPhongShapeAltitude := TBCTrackbarUpdown.Create(nil);
    FUpDownPhongShapeAltitude.Left := nextControlPos.X;
    FUpDownPhongShapeAltitude.Top := nextControlPos.Y+FPhongShapeKindToolbar.Height;
    FUpDownPhongShapeAltitude.Width := UpDownPenWidth.Width;
    FUpDownPhongShapeAltitude.Height:= UpDownPenWidth.Height;
    FUpDownPhongShapeAltitude.MinValue := 0;
    FUpDownPhongShapeAltitude.MaxValue := 100;
    FUpDownPhongShapeAltitude.Value := round(FPhongShapeAltitude);
    FUpDownPhongShapeAltitude.Hint := 'Altitude';
    FUpDownPhongShapeAltitude.ShowHint:= true;
    FUpDownPhongShapeAltitude.OnChange:=@OnPhongShapeAltitudeChange;
    PanelExtendedStyle.InsertControl(FUpDownPhongShapeAltitude);

    FUpDownPhongBorderSize := TBCTrackbarUpdown.Create(nil);
    FUpDownPhongBorderSize.Left := FUpDownPhongShapeAltitude.Left + FUpDownPhongShapeAltitude.Width + ControlMargin;
    FUpDownPhongBorderSize.Top := nextControlPos.Y+FPhongShapeKindToolbar.Height;
    FUpDownPhongBorderSize.Width := UpDownPenWidth.Width;
    FUpDownPhongBorderSize.Height:= UpDownPenWidth.Height;
    FUpDownPhongBorderSize.MinValue := 0;
    FUpDownPhongBorderSize.MaxValue := 100;
    FUpDownPhongBorderSize.Value := round(FPhongBorderSize);
    FUpDownPhongBorderSize.Enabled:= (phongShapeKind in[pskRectangle,pskRoundRectangle]);
    FUpDownPhongBorderSize.Hint := 'Border size';
    FUpDownPhongBorderSize.ShowHint:= true;
    FUpDownPhongBorderSize.OnChange:=@OnPhongBorderSizeChange;
    PanelExtendedStyle.InsertControl(FUpDownPhongBorderSize);

    nextControlPos.X := FPhongShapeKindToolbar.Left + FPhongShapeKindToolbar.Width + ControlMargin;
  end;
  PanelExtendedStyle.Width := nextControlPos.X;
end;

procedure TForm1.UpdateTitleBar;
begin
  if filename = '' then
    Caption := baseCaption + ' - New image - ' + inttostr(img.Width)+'x'+inttostr(img.Height)
  else
    Caption := baseCaption + ' - ' + filename + ' - ' + inttostr(img.Width)+'x'+inttostr(img.Height);
end;

procedure TForm1.ImageChangesCompletely;
begin
  FreeAndNil(FFlattened);
  BGRAVirtualScreen1.DiscardBitmap;
end;

function TForm1.CreateShape(const APoint1,APoint2: TPointF): TVectorShape;
var
  vectorFill: TVectorialFill;
begin
  if not IsCreateShapeTool(currentTool) then
    raise exception.Create('No shape type selected');
  result := PaintToolClass[currentTool].Create(vectorOriginal);
  if (result is TCustomPolypointShape) and (FBackFillIntf.FillType = vftGradient) then FBackFillIntf.FillType := vftSolid;
  result.PenColor := penColor;
  result.PenWidth := penWidth;
  result.PenStyle := penStyle;
  if vsfJoinStyle in result.Fields then result.JoinStyle := joinStyle;
  if currentTool in[ptClosedCurve,ptPolygon] then
    TCustomPolypointShape(result).Closed := true;
  if result is TCurveShape then TCurveShape(result).SplineStyle:= splineStyle;
  if result is TPhongShape then
  begin
    with TPhongShape(result) do
    begin
      ShapeKind:= FPhongShapeKind;
      ShapeAltitudePercent:= FPhongShapeAltitude;
      BorderSizePercent:= FPhongBorderSize;
    end;
  end;
  result.QuickDefine(APoint1,APoint2);
  if vsfBackFill in result.Fields then
  begin
    vectorFill := CreateBackFill(result);
    result.BackFill := vectorFill;
    vectorFill.Free;
  end;
end;

function TForm1.CreateBackFill(AShape: TVectorShape): TVectorialFill;
var
  grad: TBGRALayerGradientOriginal;
  rF: TRectF;
  sx,sy: single;
begin
  if FBackFillIntf.FillType = vftSolid then
    result := TVectorialFill.CreateAsSolid(FBackFillIntf.SolidColor)
  else if (FBackFillIntf.FillType = vftTexture) and Assigned(FBackFillIntf.Texture) then
  begin
    rF := AShape.GetRenderBounds(InfiniteRect,AffineMatrixIdentity,[rboAssumeBackFill]);
    if not (FBackFillIntf.TextureRepetition in [trRepeatX,trRepeatBoth]) and (rF.Width <> 0) and (FBackFillIntf.Texture.Width > 0) then
      sx:= rF.Width/FBackFillIntf.Texture.Width else sx:= 1;
    if not (FBackFillIntf.TextureRepetition in [trRepeatY,trRepeatBoth]) and (rF.Height <> 0) and (FBackFillIntf.Texture.Height > 0) then
      sy:= rF.Height/FBackFillIntf.Texture.Height else sy:= 1;

    result := TVectorialFill.CreateAsTexture(FBackFillIntf.Texture,
                 AffineMatrixTranslation(rF.TopLeft.x,rF.TopLeft.y)*
                 AffineMatrixScale(sx,sy),
                 FBackFillIntf.TextureOpacity, FBackFillIntf.TextureRepetition);
  end
  else if FBackFillIntf.FillType = vftGradient then
  begin
    grad := TBGRALayerGradientOriginal.Create;
    grad.StartColor := FBackFillIntf.GradStartColor;
    grad.EndColor := FBackFillIntf.GradEndColor;
    if Assigned(AShape) then
    begin
      rF := AShape.GetRenderBounds(rect(0,0,img.Width,img.Height),vectorTransform,[rboAssumeBackFill]);
      if IsEmptyRectF(rF) then rF := rectF(0,0,img.Width,img.Height);
    end
    else
      rF := rectF(0,0,img.Width,img.Height);
    grad.GradientType:= FBackFillIntf.GradientType;
    grad.Repetition := FBackFillIntf.GradRepetition;
    grad.ColorInterpolation:= FBackFillIntf.GradInterpolation;
    if grad.GradientType = gtLinear then
    begin
      grad.Origin := rF.TopLeft;
      grad.XAxis := rF.BottomRight;
    end else
    begin
      grad.Origin := (rF.TopLeft + rF.BottomRight)*0.5;
      if grad.GradientType = gtReflected then
        grad.XAxis := rF.BottomRight
      else
      begin
        grad.XAxis := PointF(rF.Right,grad.Origin.y);
        grad.YAxis := PointF(grad.Origin.x,rF.Bottom);
      end;
    end;
    result := TVectorialFill.CreateAsGradient(grad, true);
  end
  else result := nil; //none
end;

procedure TForm1.RemoveExtendedStyleControls;
begin
  if Assigned(FComboboxSplineStyle) then
  begin
    PanelExtendedStyle.RemoveControl(FComboboxSplineStyle);
    FreeAndNil(FComboboxSplineStyle);
  end;
  if Assigned(FSplineToolbar) then
  begin
    PanelExtendedStyle.RemoveControl(FSplineToolbar);
    FreeAndNil(FSplineToolbar);
  end;
  if Assigned(FPhongShapeKindToolbar) then
  begin
    PanelExtendedStyle.RemoveControl(FPhongShapeKindToolbar);
    FreeAndNil(FPhongShapeKindToolbar);
  end;
  if Assigned(FUpDownPhongShapeAltitude) then
  begin
    PanelExtendedStyle.RemoveControl(FUpDownPhongShapeAltitude);
    FreeAndNil(FUpDownPhongShapeAltitude);
  end;
  if Assigned(FUpDownPhongBorderSize) then
  begin
    PanelExtendedStyle.RemoveControl(FUpDownPhongBorderSize);
    FreeAndNil(FUpDownPhongBorderSize);
  end;
end;

procedure TForm1.UpdateBackToolFillPoints;
var
  canEdit: Boolean;
begin
  canEdit := (FBackFillIntf.FillType in[vftGradient,vftTexture]) and
    Assigned(vectorOriginal) and Assigned(vectorOriginal.SelectedShape);
  ButtonMoveBackFillPoints.Enabled := canEdit;
  if (currentTool = ptMoveBackFillPoint) and not canEdit then currentTool:= ptHand;
end;

procedure TForm1.UpdateShapeBackFill;
var
  vectorFill: TVectorialFill;
begin
  if Assigned(vectorOriginal) and Assigned(vectorOriginal.SelectedShape) and
    (vsfBackFill in vectorOriginal.SelectedShape.Fields) then
  begin
    if (FBackFillIntf.FillType = vftTexture) and (FBackFillIntf.TextureOpacity = 0) then
      vectorFill := nil else
    if (FBackFillIntf.FillType = vftTexture) and (vectorOriginal.SelectedShape.BackFill.FillType = vftTexture) then
    begin
      vectorFill := TVectorialFill.CreateAsTexture(FBackFillIntf.Texture, vectorOriginal.SelectedShape.BackFill.TextureMatrix,
                                                   FBackFillIntf.TextureOpacity, FBackFillIntf.TextureRepetition);
    end
    else if (FBackFillIntf.FillType = vftGradient) and (vectorOriginal.SelectedShape.BackFill.FillType = vftGradient) then
    begin
      vectorFill := vectorOriginal.SelectedShape.BackFill.Duplicate;
      vectorFill.Gradient.StartColor := FBackFillIntf.GradStartColor;
      vectorFill.Gradient.EndColor := FBackFillIntf.GradEndColor;
      vectorFill.Gradient.GradientType := FBackFillIntf.GradientType;
      vectorFill.Gradient.Repetition := FBackFillIntf.GradRepetition;
      vectorFill.Gradient.ColorInterpolation:= FBackFillIntf.GradInterpolation;
    end else
      vectorFill := CreateBackFill(vectorOriginal.SelectedShape);

    vectorOriginal.SelectedShape.BackFill:= vectorFill;
    vectorFill.Free;
  end;
end;

procedure TForm1.UpdateShapeUserMode;
begin
  if Assigned(vectorOriginal) and Assigned(vectorOriginal.SelectedShape) then
  begin
    if (currentTool = ptMoveBackFillPoint) and
       (vsfBackFill in vectorOriginal.SelectedShape.Fields) and
       vectorOriginal.SelectedShape.BackFill.IsEditable then
    begin
      if vectorOriginal.SelectedShape.Usermode <> vsuEditBackFill then
        vectorOriginal.SelectedShape.Usermode := vsuEditBackFill;
    end else
    begin
      if vectorOriginal.SelectedShape.Usermode = vsuEditBackFill then
        vectorOriginal.SelectedShape.Usermode := vsuEdit;
    end;
  end;
end;

procedure TForm1.UpdateShapeActions(AShape: TVectorShape);
begin
  ShapeBringToFront.Enabled := (AShape <> nil) and not AShape.IsFront;
  ShapeSendToBack.Enabled := (AShape <> nil) and not AShape.IsBack;
  ShapeMoveUp.Enabled := (AShape <> nil) and not AShape.IsFront;
  ShapeMoveDown.Enabled := (AShape <> nil) and not ASHape.IsBack;
  EditCopy.Enabled := AShape <> nil;
  EditCut.Enabled := AShape <> nil;
  EditDelete.Enabled := AShape <> nil;
  FBackFillIntf.CanAdjustToShape := AShape <> nil;
end;

procedure TForm1.RemoveShapeIfEmpty(AShape: TVectorShape);
var
  rF: TRectF;
begin
  if FInRemoveShapeIfEmpty then exit;
  FInRemoveShapeIfEmpty := true;
  if (AShape <> nil) and not AShape.IsRemoving then
  begin
    rF := AShape.GetRenderBounds(InfiniteRect, vectorTransform);
    if IsEmptyRectF(rF) then
    begin
      vectorOriginal.RemoveShape(AShape);
      ShowMessage('Shape is empty and has been deleted');
    end else
    if not rF.IntersectsWith(RectF(0,0,img.Width,img.Height)) then
    begin
      vectorOriginal.RemoveShape(AShape);
      ShowMessage('Shape is outside of picture and has been deleted');
    end;
  end;
  FInRemoveShapeIfEmpty := false;
end;

function TForm1.VirtualScreenToImgCoord(X, Y: Integer): TPointF;
begin
  result := AffineMatrixTranslation(-0.5,-0.5)*AffineMatrixInverse(zoom)*AffineMatrixTranslation(0.5,0.5)*PointF(X,Y);
end;

procedure TForm1.SetEditorGrid(AActive: boolean);
begin
  if Assigned(img) and Assigned(img.OriginalEditor) then
  begin
    if zoomFactor > 4 then
      img.OriginalEditor.GridMatrix := AffineMatrixTranslation(-0.5,-0.5)*
                                       vectorTransform*AffineMatrixTranslation(0.5,0.5)*
                                       AffineMatrixScale(0.5,0.5)
    else
      img.OriginalEditor.GridMatrix := AffineMatrixTranslation(-0.5,-0.5)*
                                       vectorTransform*AffineMatrixTranslation(0.5,0.5);

    img.OriginalEditor.GridActive := AActive;
  end;
end;

procedure TForm1.RequestBackFillAdjustToShape(Sender: TObject);
var
  vectorFill: TVectorialFill;
begin
  if Assigned(vectorOriginal) and Assigned(vectorOriginal.SelectedShape) then
  begin
    vectorFill := CreateBackFill(vectorOriginal.SelectedShape);
    vectorOriginal.SelectedShape.BackFill := vectorFill;
    vectorFill.Free;
  end;
end;

procedure TForm1.DoCopy;
begin
  if Assigned(vectorOriginal) and Assigned(vectorOriginal.SelectedShape) then
    CopyShapesToClipboard([vectorOriginal.SelectedShape]);
end;

procedure TForm1.DoCut;
begin
  if Assigned(vectorOriginal) and Assigned(vectorOriginal.SelectedShape) then
  begin
    if CopyShapesToClipboard([vectorOriginal.SelectedShape]) then
      vectorOriginal.SelectedShape.Remove;
  end;
end;

procedure TForm1.DoPaste;
begin
  if Assigned(vectorOriginal) then
    PasteShapesFromClipboard(vectorOriginal);
end;

procedure TForm1.DoDelete;
begin
  if Assigned(vectorOriginal) and Assigned(vectorOriginal.SelectedShape) then
    vectorOriginal.SelectedShape.Remove;
end;

end.

