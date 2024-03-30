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
    public class RequisitesController : ControllerBase
    {
        private readonly ChessClubContext _context;

        public RequisitesController(ChessClubContext context)
        {
            _context = context;
        }

        // GET: api/Requisites
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Requisite>>> GetRequisites()
        {
          if (_context.Requisites == null)
          {
              return NotFound();
          }
            return await _context.Requisites.ToListAsync();
        }

        // GET: api/Requisites/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Requisite>> GetRequisite(int id)
        {
          if (_context.Requisites == null)
          {
              return NotFound();
          }
            var requisite = await _context.Requisites.FindAsync(id);

            if (requisite == null)
            {
                return NotFound();
            }

            return requisite;
        }

        // PUT: api/Requisites/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutRequisite(int id, Requisite requisite)
        {
            if (id != requisite.RequisitesId)
            {
                return BadRequest();
            }

            _context.Entry(requisite).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!RequisiteExists(id))
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

        // POST: api/Requisites
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<Requisite>> PostRequisite(Requisite requisite)
        {
          if (_context.Requisites == null)
          {
              return Problem("Entity set 'ChessClubContext.Requisites'  is null.");
          }
            _context.Requisites.Add(requisite);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetRequisite", new { id = requisite.RequisitesId }, requisite);
        }

        // DELETE: api/Requisites/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteRequisite(int id)
        {
            if (_context.Requisites == null)
            {
                return NotFound();
            }
            var requisite = await _context.Requisites.FindAsync(id);
            if (requisite == null)
            {
                return NotFound();
            }

            _context.Requisites.Remove(requisite);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool RequisiteExists(int id)
        {
            return (_context.Requisites?.Any(e => e.RequisitesId == id)).GetValueOrDefault();
        }
    }
}
