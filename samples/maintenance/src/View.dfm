object frmMaintenance: TfrmMaintenance
  Left = 0
  Top = 0
  Caption = 'frmMaintenance'
  ClientHeight = 214
  ClientWidth = 708
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 689
    Height = 201
    Caption = 'Maintenance'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI Black'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object GroupBox2: TGroupBox
      Left = 32
      Top = 40
      Width = 305
      Height = 137
      Caption = 'Queue'
      TabOrder = 0
      object edtQueue: TEdit
        Left = 16
        Top = 48
        Width = 273
        Height = 29
        TabOrder = 0
        TextHint = 'Enter Queue Name'
      end
      object btnDeclareQueue: TButton
        Left = 16
        Top = 96
        Width = 75
        Height = 25
        Caption = 'Declare'
        TabOrder = 1
        OnClick = btnDeclareQueueClick
      end
      object btnDeleteQueue: TButton
        Left = 115
        Top = 96
        Width = 75
        Height = 25
        Caption = 'Delete'
        TabOrder = 2
        OnClick = btnDeleteQueueClick
      end
      object btnBindQueue: TButton
        Left = 214
        Top = 96
        Width = 75
        Height = 25
        Caption = 'Bind'
        TabOrder = 3
        OnClick = btnBindQueueClick
      end
    end
    object GroupBox3: TGroupBox
      Left = 352
      Top = 40
      Width = 305
      Height = 137
      Caption = 'Exchange'
      TabOrder = 1
      object edtExchange: TEdit
        Left = 16
        Top = 48
        Width = 273
        Height = 29
        TabOrder = 0
        TextHint = 'Enter Exchange Name'
      end
      object btnDeclareExchange: TButton
        Left = 16
        Top = 96
        Width = 75
        Height = 25
        Caption = 'Declare'
        TabOrder = 1
        OnClick = btnDeclareExchangeClick
      end
      object btnDeleteExchange: TButton
        Left = 115
        Top = 96
        Width = 75
        Height = 25
        Caption = 'Delete'
        TabOrder = 2
        OnClick = btnDeleteExchangeClick
      end
      object btnBindExchange: TButton
        Left = 214
        Top = 96
        Width = 75
        Height = 25
        Caption = 'Bind'
        TabOrder = 3
        OnClick = btnBindExchangeClick
      end
    end
  end
end
