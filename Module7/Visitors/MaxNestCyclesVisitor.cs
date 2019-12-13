using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ProgramTree;

namespace SimpleLang.Visitors
{
    public class MaxNestCyclesVisitor : AutoVisitor
    {
        public int MaxNest = 0;
        public int levelVisted = 0;
        public override void VisitCycleNode(CycleNode c)
        {
            levelVisted += 1;
            if (levelVisted > MaxNest)
            {
                MaxNest = levelVisted;
            }
            base.VisitCycleNode(c);
            levelVisted -= 1;
        }
    }
}
