object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 619
  ClientWidth = 1092
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object GroupBox1: TGroupBox
    Left = 5
    Top = 8
    Width = 1081
    Height = 605
    Caption = 'Consumer'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'Segoe UI Black'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Label1: TLabel
      Left = 281
      Top = 37
      Width = 469
      Height = 37
      Caption = 'Consume multiple queues sincroniz'
    end
    object btnStop1: TButton
      Left = 170
      Top = 503
      Width = 105
      Height = 34
      Caption = 'Stop'
      TabOrder = 0
      OnClick = btnStop1Click
    end
    object btnStart1: TButton
      Left = 18
      Top = 503
      Width = 105
      Height = 34
      Caption = 'Start'
      TabOrder = 1
      OnClick = btnStart1Click
    end
    object Memo1: TMemo
      Left = 18
      Top = 135
      Width = 257
      Height = 362
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 2
    end
    object edtQueue: TEdit
      Left = 18
      Top = 80
      Width = 257
      Height = 45
      TabOrder = 3
      TextHint = 'Enter Queue name'
    end
    object Memo2: TMemo
      Left = 281
      Top = 135
      Width = 257
      Height = 362
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 4
    end
    object btnStop2: TButton
      Left = 433
      Top = 503
      Width = 105
      Height = 34
      Caption = 'Stop'
      TabOrder = 5
      OnClick = btnStop1Click
    end
    object btnStart2: TButton
      Left = 281
      Top = 503
      Width = 105
      Height = 34
      Caption = 'Start'
      TabOrder = 6
      OnClick = btnStart1Click
    end
    object edtQueue2: TEdit
      Left = 281
      Top = 80
      Width = 257
      Height = 45
      TabOrder = 7
      TextHint = 'Enter Queue name'
    end
    object Memo3: TMemo
      Left = 544
      Top = 135
      Width = 257
      Height = 362
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 8
    end
    object btnStop3: TButton
      Left = 696
      Top = 503
      Width = 105
      Height = 34
      Caption = 'Stop'
      TabOrder = 9
      OnClick = btnStop1Click
    end
    object btnStart3: TButton
      Left = 544
      Top = 503
      Width = 105
      Height = 34
      Caption = 'Start'
      TabOrder = 10
      OnClick = btnStart1Click
    end
    object edtQueue3: TEdit
      Left = 544
      Top = 80
      Width = 257
      Height = 45
      TabOrder = 11
      TextHint = 'Enter Queue name'
    end
    object Memo4: TMemo
      Left = 807
      Top = 135
      Width = 257
      Height = 362
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 12
    end
    object btnStop4: TButton
      Left = 959
      Top = 503
      Width = 105
      Height = 34
      Caption = 'Stop'
      TabOrder = 13
      OnClick = btnStop1Click
    end
    object btnStart4: TButton
      Left = 807
      Top = 503
      Width = 105
      Height = 34
      Caption = 'Start'
      TabOrder = 14
      OnClick = btnStart1Click
    end
    object edtQueue4: TEdit
      Left = 807
      Top = 80
      Width = 257
      Height = 45
      TabOrder = 15
      TextHint = 'Enter Queue name'
    end
  end
end
