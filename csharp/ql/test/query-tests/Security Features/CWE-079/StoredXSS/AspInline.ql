import csharp
import semmle.code.csharp.security.dataflow.XSS

string tweakMemberLocation(XSS::AspInlineMember inline, Member member) {
  exists(Location loc |
    loc = member.getLocation() and
    if loc.getFile().getParentContainer() = inline.getLocation().getFile().getParentContainer()
    then result = loc.toString()
    else result = "<outside test directory>"
  )
}

from XSS::AspInlineMember inline, Member member
where member = inline.getMember()
// some members, such as ASP members inherited from DLLs, are outside the test directory,
// so we select them specially using a modified location and the normal toString
select inline, tweakMemberLocation(inline, member), member.toString()
