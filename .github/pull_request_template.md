## Summary

- What changed?
- Why is this change needed?

## dbt Checklist

- [ ] I declared or verified model grain
- [ ] I added or updated YAML documentation
- [ ] I added or updated dbt tests
- [ ] I verified schema placement (`b2_int` vs `b2_mart`)
- [ ] I considered downstream Power BI/app usage

## Agent Checklist

- [ ] Model Author Agent used when modeling changed
- [ ] Test Agent used when tests changed or were needed
- [ ] Documentation Agent used when docs changed or were missing
- [ ] Reviewer Agent findings addressed before merge

## Validation

- [ ] `dbt deps`
- [ ] `dbt parse`
- [ ] `dbt compile`
- [ ] `dbt build`
- [ ] `dbt test`

## Notes

- Assumptions:
- Risks:
