unit APIUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs;

type

  TForm2 = class(TForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

type


//  TInfo = record
//    RequestArr: array [0..20] of string;
////    typeOfReq: byte;
//    case typeOfReq:(0,1) of
//    0:  (AnswerArr: string [1..20] of string);
//    1:  (TypeOfAction: integer);
//  end;

//  TReqInfo = record
//    ReqArr: array [0..100] of shortString;
//    TypeOfReq: Boolean;
//  end;
//
//  TAnsInfo = record
//    case TypeOfReq of
//      False: (AnsArr: array [1..20] of string);
//      true: (Action: byte);
//  end;


//  TUsefulData = record
//    ReqInfo: TReqInfo;
//    AnsInfo: TAnsInfo;
//  end;
  TUsefulData = record
    ReqArr: array [0..100] of shortString;
    AnsArr: array [0..100] of shortString;
  end;

  Ptr = ^TElement;
  TElement = record
    next, prev: Ptr;
    data: TusefulData;
  end;

  TList = record
    head, tail: Ptr;
  end;

var
  Form2: TForm2;
  F: file of TUsefulData;

procedure CreateList (var list: TList);
procedure FormatInput(var s: string);
procedure AddNewEl (var list: TList; var curr: Ptr);
procedure FindAns (const UserRequest: String; var List: TList);

implementation

{$R *.dfm}

procedure FormatInput(var s: string);
var
  i: byte;
begin
  for i := (length(s) - 1) downto 1 do
  begin
    if (s[i] = ' ') and (s[i + 1] = ' ') then
    begin
      delete(s, i + 1, 1)
    end;
  end;
  trim(s);
  for i := 1 to length(s) do
  begin
    if s[i] in ['A'..'Z', 'À'..'ß'] then
      s[i] := chr(ord(s[i]) + 32);
    if s[i] in ['`','~','#','^','&','{','}','\'] then
      delete(s,pos(s[i],s),1);
  end;
end;

procedure CreateList (var list: TList);
var
  curr, tmp: Ptr;
begin
  list.head := nil;
  list.tail := nil;
  assignFile(F,'Files\Requests.txt');
  reset(F);
  new(curr);
  if FileSize(f) <> 0 then
  begin
    read(F,curr.data);
    addNewEl(List,curr);
    while not Eof (F) do
    begin
      tmp := curr;
      new(curr);
      read(F,curr.data);
      AddNewEl(List,curr);
    end;
  end;
end;

procedure AddNewEl (var list: TList; var curr: Ptr);
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

procedure FindAns (const UserRequest: String; var List: TList);
var
  curr, tmp: Ptr;
  I: Integer;
begin
  curr := list.head;
  while curr <> nil do
  begin
    for I := 1 to length(curr.data.ReqArr) do
    begin
      if UserRequest = curr.data.ReqArr[i] then
      begin
      
        exit;
      end;
      curr := curr.next;
    end;

  end;

end;


end.
