unit Test.UriBuilder;

interface

{$M+}

uses
  DUnitX.TestFramework,
  Nathan.UriBuilder;

type
  [TestFixture]
  TTestUriBuilder = class
  strict private
    FCut: IUriBuilder;
  private const StartUrl = 'http://webto.parts.com/loginh.aspx';
  public
    [Setup]
    procedure Setup();

    [TearDown]
    procedure TearDown();

    [Test]  //    [Ignore('Ignore this test')]
    procedure Test_HasNoMemoryLeaks_ByToString;

    [Test]
    [TestCase('Scheme01', 'http://webto.parts.com/loginh.aspx,http')]
    [TestCase('Scheme02', 'https://webto.parts.com/loginh.aspx,https')]
    procedure Test_HasCorrectly_Scheme(const Value, Correctly: string);

    [Test]
    [TestCase('AddParameter01', 'nathan,chanan,nathan=ch')]
    [TestCase('AddParameter02', 'brand,delphi,brand=delphi')]
    procedure Test_HasCorrectly_AddParameter_FromDerivedClass(const AName, AValue, AExpected: string);

    [Test]
    procedure Test_HasCorrectly_DeleteParameter_FromDerivedClass;

    [Test]
    procedure Test_HasCorrectly_Parameter_HelloShort;

    [Test]
    procedure Test_CreateWithEmptyConstructor;

    [Test]
    procedure Test_AddParameter_WithTFunc;

    [Test]
    procedure Test_HasAnExceptionOnValidator;

    [Test]
    procedure Test_AddParameter_WithEmptyValue;

    [Test]
    procedure Test_AddParameter_WithIgnoreOneParameter;

    [Test]
    procedure Test_AddParameter_WithIgnoreOneParameterAndAll;
  end;

{$M-}

implementation

uses
  System.SysUtils,
  Derived.UriBuilder.Demo,
  Nathan.UriBuilder.Validator;

procedure TTestUriBuilder.Setup();
begin
  FCut := nil;
end;

procedure TTestUriBuilder.TearDown();
begin
  FCut := nil;
end;

procedure TTestUriBuilder.Test_HasNoMemoryLeaks_ByToString;
var
  Actual: string;
begin
  //  Arrange...
  FCut := TUriBuilder.Create('http://www.google.ch');
  FCut.AddParameter('11', '111');

  //  Act...
  Actual := FCut.ToString;

  //  Assert...
  Assert.IsNotNull(FCut);
end;

procedure TTestUriBuilder.Test_HasCorrectly_Scheme;
var
  Actual: string;
begin
  //  Arrange...
  FCut := TUriBuilder.Create(Value);

  //  Act...
  Actual := FCut.Scheme;

  //  Assert...
  Assert.AreEqual(Correctly, Actual);
end;

procedure TTestUriBuilder.Test_HasCorrectly_AddParameter_FromDerivedClass;
var
  Actual: string;
begin
  //  Arrange...
  FCut := TNathanUriBilder.Create(StartUrl);

  //  Act...
  Actual := FCut
    .AddParameter(AName, AValue)
    .ToString;

  //  Assert...
  Assert.IsTrue(Actual.EndsWith(AExpected));
end;

procedure TTestUriBuilder.Test_HasCorrectly_DeleteParameter_FromDerivedClass;
var
  Actual: string;
begin
  //  Arrange...
  FCut := TNathanUriBilder.Create(StartUrl);
  FCut.AddParameter('nathan', 'chanan');
  FCut.AddParameter('paramname', 'thurnreiter');

  //  Act...
  FCut.DeleteParameter('nathan');
  Actual := FCut.ToString;

  //  Assert...
  Assert.AreEqual('http://webto.parts.com/loginh.aspx?paramname=thurnreiter', Actual);
end;

procedure TTestUriBuilder.Test_HasCorrectly_Parameter_HelloShort;
var
  Actual: string;
begin
  //  Arrange...
  FCut := TNathanUriBilder.Create(StartUrl);
  FCut.AddParameter('helloshort', 'chanan');

  //  Act...
  Actual := FCut.ToString;

  //  Assert...
  Assert.AreEqual('http://webto.parts.com/loginh.aspx?helloshort=ch', Actual);
end;

procedure TTestUriBuilder.Test_CreateWithEmptyConstructor;
var
  Actual: string;
begin
  //  Arrange...
  FCut := TNathanUriBilder.Create(StartUrl);

  //  Act...
  Actual := FCut
    .Scheme('https')
    .Host('webto.parts.com')
    .Port(80)
    .Path('index.html')
    .AddParameter('helloshort', 'chanan')
    .ToString;

  //  Assert...
  Assert.AreEqual('https://webto.parts.com:80/index.html?helloshort=ch', Actual);
end;

procedure TTestUriBuilder.Test_AddParameter_WithTFunc;
var
  Actual: string;
begin
  //  Arrange...
  FCut := TNathanUriBilder.Create(StartUrl);

  //  Act...
  Actual := FCut
    .AddParameter('nathan', 'chanan')
    .AddParameter('pname',
      function: string
      begin
        Result := 'thu';
      end)
    .ToString;

  //  Assert...
  Assert.AreEqual('http://webto.parts.com/loginh.aspx?nathan=ch&pname=thu', Actual);
end;

procedure TTestUriBuilder.Test_HasAnExceptionOnValidator;
begin
 Assert.WillRaiseWithMessage(
    procedure
    begin
      FCut := TNathanUriBilderEx.Create(StartUrl);
      FCut
        .AddParameter('helloexception', 'chanan')
        .ToString;
    end,
    EInvalidUriValidatorValue,
    'Invalid value for the parameter.');
end;

procedure TTestUriBuilder.Test_AddParameter_WithEmptyValue;
var
  Actual: string;
begin
  //  Arrange...
  FCut := TNathanUriBilderEx
    .Create(StartUrl)
    .AddParameter('nathan', 'chanan')
    .AddParameter('emptyparamname', '')
    .AddParameter('SameEmpty', '')
    .AddParameter('anyafter', 'next');

  //  Act...
  Actual := FCut.ToString;

  //  Assert...
  Assert.AreEqual('http://webto.parts.com/loginh.aspx?nathan=ch&anyafter=next', Actual);
end;

procedure TTestUriBuilder.Test_AddParameter_WithIgnoreOneParameter;
var
  Actual: string;
begin
  //  Arrange...
  FCut := TNathanUriBilderIgnore
    .Create(StartUrl)
    .AddParameter('chanan', '')
    .AddParameter('emptyparam', '')
    .AddParameter('key', 'value');

  //  Act...
  Actual := FCut.ToString;

  //  Assert...
  Assert.AreEqual('http://webto.parts.com/loginh.aspx?emptyparam=&key=value', Actual);
end;

procedure TTestUriBuilder.Test_AddParameter_WithIgnoreOneParameterAndAll;
var
  Actual: string;
begin
  //  Arrange...
  FCut := TNathanUriBilderIgnore2
    .Create(StartUrl)
    .AddParameter('chanan', '')
    .AddParameter('emptyparam', '')
    .AddParameter('key', 'value');

  //  Act...
  Actual := FCut.ToString;

  //  Assert...
  Assert.AreEqual('http://webto.parts.com/loginh.aspx?key=value', Actual);
end;

initialization
  TDUnitX.RegisterTestFixture(TTestUriBuilder, 'UriBuilder');

end.
