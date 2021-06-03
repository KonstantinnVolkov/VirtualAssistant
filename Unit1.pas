unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Menus,
  Vcl.ToolWin, Vcl.ComCtrls;

type
//  TDialogue = record
//    request, answer, buf: ShortString;
//  end;
  TForm1 = class(TForm)
    BWeather: TButton;
    BAfisha: TButton;
    BNews: TButton;
    Label1: TLabel;
    Image1: TImage;
    mMenu: TMainMenu;
    darkTheme: TMenuItem;
    brightTheme: TMenuItem;
    customTheme: TMenuItem;
    ColorDialog: TColorDialog;
    ERequest: TEdit;
    PDialogue: TPanel;
    MDialogue: TMemo;
    procedure BWeatherClick(Sender: TObject);
    procedure BAfishaClick(Sender: TObject);
    procedure BNewsClick(Sender: TObject);
    procedure darkThemeClick(Sender: TObject);
    procedure brightThemeClick(Sender: TObject);
    procedure customThemeClick(Sender: TObject);
    procedure ERequestChange(Sender: TObject);
    procedure ERequestKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  ShellApi;                     //Библиотека для работы с приложениями

{$R *.dfm}

var
  TestFile: File of ShortString;                 //file of TDialogue
 // Requests, Answers, FactsFile: TStringList;
  Request: String;

procedure TForm1.FormCreate(Sender: TObject);
begin
  //Requests := TStringList.Create;
  //Requests.LoadFromFile('Requests.txt');
  //Answers := TStringList.Create;
  //Answers.LoadFromFile('Answers.txt');
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  ERequest.SetFocus;
end;

procedure TForm1.ERequestChange(Sender: TObject);
var
  i: byte;
begin
  i := length(ERequest.Text);
  SetLength(request,i);
  request := ERequest.Text;
end;

procedure TForm1.ERequestKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
const
  enter = 13;
var
  i, j, k :integer;
  Str, finalAnswer, Answers :ShortString;
  AnsArray : array of ShortString;
  flag: Boolean;
begin
  if key = enter then
  begin
    randomize;
    AssignFile(TestFile,'TestFile.txt');
    reset(TestFile);
    flag := false;
    i := 1;
    setLength(ansArray,i);
    pDialogue.Visible := true;
    Request := LowerCase(ERequest.text);
    MDialogue.Alignment := taLeftJustify;
    MDialogue.lines.Add('Вы: ' + request);
    while not (Eof(TestFile)) do
    begin
      readLn(TestFile,Str);
      if pos(request,Str)<>0 then
      begin
        flag := true;
        request := copy(Str, 1, pos(Str,'=')-1);
        answers := copy (Str, pos(Str,'=')+1, length(Str));
        j := 0;
        while True do
        begin
          if pos(answers,',') = 0 then break;
          ansArray[j] := copy(answers, 1 ,pos(answers,',')-1);
          delete(answers, 1, pos(answers,','));
          inc(i);
          inc(j);     
          setLength(AnsArray,i); 
        end;
      end;
      if flag then break;
    end;
    FinalAnswer := AnsArray[random(length(AnsArray))];
    MDialogue.lines.Add('Eve: ' + FinalAnswer);
    ERequest.text := '';




                                                              //TODO
//    for I := 0 to Requests.Count - 1  do                      //3: Добавить в файл Facts какие-либо факты, которые ассистент
//    begin                                                     //будет предлагать случайно
//      k := pos('=',Requests[i]) - 1;                          //4: Попробовать реализовать что-то на подобие мат.помощника
//      buf := copy (Requests[i],1,k);                          //5: Может быть возможность создания напоминаний
//      if buf = request then                                   //6: На какую тему хоитте поговорить?
//      begin
//        ReqID := StrToInt( copy (Requests[i],k+2,1) );
//        j := 0;
//        AnsID := StrToInt ( copy (answers[j],1,1) );
//        k := 0;
//        while reqID >= AnsID do
//        begin
//          if reqID = AnsID then
//          begin
//            SetLength(AnsArray,k+1);
//            AnsArray[k] := copy(answers[j],3,length(answers[j]));
//            inc(k);
//          end;
//          inc(j);
//          watch := answers.Count;
//          if j >= answers.Count then break
//          else
//          AnsID := StrToInt ( copy (answers[j],1,1) );
//        end;
//        //MDialogue.Alignment := taLeftJustify;
//        finalAnswer := AnsArray[random(k)];
//        MDialogue.lines.Add('Eve: ' + finalAnswer);
//        ERequest.text := '';
//        break;
//      end;
//    end;
  end;

end;

procedure TForm1.customThemeClick(Sender: TObject);    //Interface
begin
  if colorDialog.Execute then
    begin
      form1.Color := colorDialog.Color;
      label1.Font.Color := clBlack;
      pdialogue.Color := colorDialog.Color;
      mDialogue.Color := colorDialog.Color;
      mDialogue.Font.Color := clBlack;
    end;
end;

procedure TForm1.darkThemeClick(Sender: TObject);
begin
  form1.color := clBlack;
  pdialogue.Color := clBlack;
  mDialogue.Color := clBlack;
  MDialogue.Font.Color := clWhite;
end;

procedure TForm1.brightThemeClick(Sender: TObject);
begin
  form1.color := clWhite;
  pdialogue.Color := clWhite;
  mDialogue.Color := clWhite;
  mDialogue.Font.Color := clBlack;
  label1.font.Color := clBlack;

end;

procedure TForm1.BAfishaClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'https://afisha.tut.by/',
    nil, nil, SW_SHOWNORMAL) ;
end;

procedure TForm1.BNewsClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'https://www.tut.by/',
    nil, nil, SW_SHOWNORMAL) ;
end;

procedure TForm1.BWeatherClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'https://www.accuweather.com/ru/by/minsk/28580/weather-forecast/28580',
    nil, nil, SW_SHOWNORMAL) ;
end;

end.
