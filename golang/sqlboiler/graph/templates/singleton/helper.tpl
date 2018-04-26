const (
  // defaultPageSize is used in AllXxx query methods `args.PageSize`
  defaultPageSize = 25
)


// QueryModPageSize returns an SQLBoiler QueryMod limit based on the argument
func QueryModPageSize(pageSize *int) qm.QueryMod {
  l := defaultPageSize // Default page size
	if pageSize != nil {
		l = *pageSize
	}
  return qm.Limit(l)
}

// QueryModOffset returns an SQLBoiler QueryMod offset based on the argument
func QueryModOffset(offset *graphql.ID) (qm.QueryMod, error) { 
  if offset == nil {
    return qm.Offset(0), nil
  }

  s := string(*offset)
  i, err := strconv.ParseInt(s, 10, 64)
  if err != nil {
    return nil, err
  }
  return qm.Offset(int(i)), nil
}

// QueryModsSearch returns a list of QueryMod based on the struct values
func QueryModsSearch(input interface{}) []qm.QueryMod {
  mods := []qm.QueryMod{}
  // Get reflect value
  v := reflect.ValueOf(input).Elem()
  // Iterate struct fields
  for i := 0; i < v.NumField(); i++ {
    field := v.Type().Field(i) // StructField
    value := v.Field(i) // Value
    if value.IsNil() || !value.IsValid() {
      // Skip if field is nil
      continue
    }

    // Get column name from tags
    column, hasColumnName := field.Tag.Lookup("json")
    // Skip if no DB definition
    if !hasColumnName {
      continue
    }

    operator := "="
    val := value.Elem().Interface()
    if dataType := field.Type.String(); (dataType == "string" || dataType == "*string") &&
      val.(string) != "" {
      operator = "LIKE"
      val = fmt.Sprintf("%%%s%%", val)
    }
    mods = append(mods, qm.And(fmt.Sprintf("%s %s ?", column, operator), val))
  }
  return mods
}
