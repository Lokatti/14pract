using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using ApiChessClub.Models;

namespace ApiChessClub.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class GroupTypesController : ControllerBase
    {
        private readonly ChessClubContext _context;

        public GroupTypesController(ChessClubContext context)
        {
            _context = context;
        }

        // GET: api/GroupTypes
        [HttpGet]
        public async Task<ActionResult<IEnumerable<GroupType>>> GetGroupTypes()
        {
          if (_context.GroupTypes == null)
          {
              return NotFound();
          }
            return await _context.GroupTypes.ToListAsync();
        }

        // GET: api/GroupTypes/5
        [HttpGet("{id}")]
        public async Task<ActionResult<GroupType>> GetGroupType(int id)
        {
          if (_context.GroupTypes == null)
          {
              return NotFound();
          }
            var groupType = await _context.GroupTypes.FindAsync(id);

            if (groupType == null)
            {
                return NotFound();
            }

            return groupType;
        }

        // PUT: api/GroupTypes/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutGroupType(int id, GroupType groupType)
        {
            if (id != groupType.GroupTypeId)
            {
                return BadRequest();
            }

            _context.Entry(groupType).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!GroupTypeExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        // POST: api/GroupTypes
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<GroupType>> PostGroupType(GroupType groupType)
        {
          if (_context.GroupTypes == null)
          {
              return Problem("Entity set 'ChessClubContext.GroupTypes'  is null.");
          }
            _context.GroupTypes.Add(groupType);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetGroupType", new { id = groupType.GroupTypeId }, groupType);
        }

        // DELETE: api/GroupTypes/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteGroupType(int id)
        {
            if (_context.GroupTypes == null)
            {
                return NotFound();
            }
            var groupType = await _context.GroupTypes.FindAsync(id);
            if (groupType == null)
            {
                return NotFound();
            }

            _context.GroupTypes.Remove(groupType);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool GroupTypeExists(int id)
        {
            return (_context.GroupTypes?.Any(e => e.GroupTypeId == id)).GetValueOrDefault();
        }
    }
}
