describe "ruc jquery validator plugin", ->

  it "should have already loaded jQuery 1.9.1 in $", ->
    expect($.fn.jquery).toEqual "1.9.1"
