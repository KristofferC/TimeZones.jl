import Base.Dates: trunc, DatePeriod, TimePeriod
import Base.Dates: firstdayofweek, lastdayofweek, firstdayofmonth, lastdayofmonth,
    firstdayofyear, lastdayofyear, firstdayofquarter, lastdayofquarter


# Truncation
function trunc{P<:DatePeriod}(zdt::ZonedDateTime, ::Type{P})
    ZonedDateTime(trunc(localtime(zdt), P), timezone(zdt))
end
function trunc{P<:TimePeriod}(zdt::ZonedDateTime, ::Type{P})
    ZonedDateTime(trunc(utc(zdt), P), timezone(zdt), from_utc=true)
end
trunc(zdt::ZonedDateTime, ::Type{Millisecond}) = zdt

# Adjusters
for prefix in ("firstdayof", "lastdayof"), suffix in ("week", "month", "year", "quarter")
    func = Symbol(prefix * suffix)
    @eval begin
        $func(dt::ZonedDateTime) = ZonedDateTime($func(localtime(dt)), dt.timezone)
    end
end
