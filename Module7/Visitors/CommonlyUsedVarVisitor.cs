using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ProgramTree;

namespace SimpleLang.Visitors
{
    public class CommonlyUsedVarVisitor : AutoVisitor
    {
        Dictionary<String, int> names = new Dictionary<string, int>();
        public string mostCommonlyUsedVar()
        {
            return names.Aggregate((x, y) => x.Value > y.Value ? x : y).Key;
        }

        public override void VisitIdNode(IdNode id)
        {
            if (names.ContainsKey(id.Name))
            {
                names[id.Name] += 1;
            }
            else
            {
                names[id.Name] = 1;
            }

            base.VisitIdNode(id);
        }
    }
}
