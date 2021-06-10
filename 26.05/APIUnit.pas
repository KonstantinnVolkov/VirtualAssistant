unit APIUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ShellApi,SpeechLib_TLB, math;

type

  TForm2 = class(TForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

type

  TUsefulData = record
    Req: String[255];
    case TypeOfReq: boolean of
      true: (Ans: String[255]);
      false: (
                NumberOfAction: integer;
                Link: ShortString
             );
  end;

  Ptr = ^TElement;
  TElement = record
    next, prev: Ptr;
    data: TUsefulData;
  end;

  TList = record
    head, tail: Ptr;
  end;

var
  Form2: TForm2;
  Brains: file of TUsefulData;
  Jokes: file of ShortString;
  List: TList;

procedure CreateList ();
procedure FormatInput(var s: string);
procedure AddNewEl (var curr: Ptr);
procedure FindAns (const UserRequest: String; Voice: Boolean; var AnsNotFound: Boolean);
procedure Action (const NumOfAction: integer; const Link: String; Voice: Boolean);

implementation

uses
  MainForm;

{$R *.dfm}

procedure FormatInput(var s: string);
var
  i: byte;
begin
  for i := (length(s)) downto 1 do
  begin
    if (s[i] = ' ') and (s[i + 1] = ' ') then
    begin
      delete(s, i + 1, 1)
    end;
  end;
  AnsiLowerCase(s);
  for i := 1 to length(s) do
  begin
    if s[i] in ['`','~','#','^','&','{','}','\'] then
      delete(s,pos(s[i],s),1);
  end;
end;

procedure CreateList;
var
  curr, tmp: Ptr;
begin
  AssignFile(Brains,'Brains.txt');

  List.head := nil;
  list.tail := nil;
  new(curr);

  reset(Brains);
  read(Brains, curr.data);

  AddNewEl ( curr);

  while not Eof(Brains) do
  begin
    tmp := curr;
    new(curr);
    read(Brains,curr.data);
    AddNewEl(curr);
    tmp.next := curr;
    curr.prev := tmp;
  end;

  closeFile(Brains);
  dispose(curr);
end;

procedure AddNewEl (var curr: Ptr);
begin
  if list.head = nil then
  begin
    list.head := curr;
    list.tail := curr;
    curr.next := nil;
    curr.prev := nil;
    exit;
  end;

  curr.next := nil;
  curr.prev := list.tail;
  list.tail.next := curr;
  list.tail := curr;
end;

procedure FindAns (const UserRequest: String; Voice: Boolean; var AnsNotFound: Boolean);
var
  curr: Ptr;
  AnsArr: Array of string;
  phrase: string;
  i, j: byte;
  flag: boolean;
begin
  Randomize;
  new(curr);
  curr := list.head;
  flag := false;

  while curr <> nil do
  begin
    if pos(UserRequest, curr.data.Req) <> 0 then
    begin
      case curr.data.TypeOfReq of
      true:
        begin
          SetLength(AnsArr,0);
          i := 0;
          j := 1;
          SetLength(AnsArr,i+1);
          phrase := '';
          while True do
          begin
            if curr.data.Ans[j] = '┐' then
            begin
              AnsArr[i] := phrase;
              phrase := '';
              inc(i);
              SetLength(AnsArr,i+1);
              inc(j)
            end
            else
            begin
              phrase := phrase + curr.data.Ans[j];
              inc(j)
            end;

            if j = length(curr.data.Ans) then
            begin
              phrase := '';
              phrase := AnsArr[ randomRange(0, Length(AnsArr)-1 ) ];
              if voice then
              begin
                MainForm.Form1.MDialogue.Lines.Add('Eve: ' + phrase );
                MainForm.Form1.SpVoice1.Speak(phrase,SVSFlagsAsync);
                exit;
              end
              else
              begin
                MainForm.Form1.MDialogue.Lines.Add('Eve: ' + phrase );
                exit;
              end;
            end;
          end;

          flag := true;
        end;

      False:
        begin
          Action(curr.data.NumberOfAction, curr.data.Link, Voice);
          flag := true;
        end;
      end;
    end;

    curr := curr.next;
  end;

  if not (flag) then AnsNotFound := true;
end;

procedure Action (const NumOfAction: integer; const Link: String; Voice: Boolean);
var
  jokesArr: array of ShortString;
  i: integer;
  Joke: ShortString;
begin
  case NumOfAction of
  0:
    begin
      MainForm.Form1.MDialogue.Lines.Add('Eve: Сегодня '+ FormatDateTime('dddddd', now) );
      if voice then
        MainForm.Form1.SpVoice1.Speak('Сегодня' + FormatDateTime('dddddd', now), SVSFlagsAsync);
    end;
  1:
    ShellExecute(0, 'open', PWideChar(Link), nil, nil, SW_SHOWNORMAL);
  2:
    begin
      Randomize;
      AssignFile(Jokes,'Jokes.txt');
      reset(Jokes);
      i := 0;
      while not Eof (Jokes) do
      begin
        SetLength(JokesArr,i+1);
        read(Jokes,JokesArr[i]);
        inc(i);
      end;
      Joke := JokesArr[ randomRange(1, Length(JokesArr)-1 ) ];
      if voice then
        MainForm.Form1.SpVoice1.Speak(joke ,SVSFlagsAsync);
      MainForm.Form1.MDialogue.Lines.Add('Eve: ' + joke );
      CloseFile(Jokes);
    end;
  end;
end;

end.

