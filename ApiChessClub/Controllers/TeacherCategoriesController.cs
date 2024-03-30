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
    public class TeacherCategoriesController : ControllerBase
    {
        private readonly ChessClubContext _context;

        public TeacherCategoriesController(ChessClubContext context)
        {
            _context = context;
        }

        // GET: api/TeacherCategories
        [HttpGet]
        public async Task<ActionResult<IEnumerable<TeacherCategory>>> GetTeacherCategories()
        {
          if (_context.TeacherCategories == null)
          {
              return NotFound();
          }
            return await _context.TeacherCategories.ToListAsync();
        }

        // GET: api/TeacherCategories/5
        [HttpGet("{id}")]
        public async Task<ActionResult<TeacherCategory>> GetTeacherCategory(int id)
        {
          if (_context.TeacherCategories == null)
          {
              return NotFound();
          }
            var teacherCategory = await _context.TeacherCategories.FindAsync(id);

            if (teacherCategory == null)
            {
                return NotFound();
            }

            return teacherCategory;
        }

        // PUT: api/TeacherCategories/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutTeacherCategory(int id, TeacherCategory teacherCategory)
        {
            if (id != teacherCategory.TeacherCategoryId)
            {
                return BadRequest();
            }

            _context.Entry(teacherCategory).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!TeacherCategoryExists(id))
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

        // POST: api/TeacherCategories
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<TeacherCategory>> PostTeacherCategory(TeacherCategory teacherCategory)
        {
          if (_context.TeacherCategories == null)
          {
              return Problem("Entity set 'ChessClubContext.TeacherCategories'  is null.");
          }
            _context.TeacherCategories.Add(teacherCategory);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetTeacherCategory", new { id = teacherCategory.TeacherCategoryId }, teacherCategory);
        }

        // DELETE: api/TeacherCategories/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteTeacherCategory(int id)
        {
            if (_context.TeacherCategories == null)
            {
                return NotFound();
            }
            var teacherCategory = await _context.TeacherCategories.FindAsync(id);
            if (teacherCategory == null)
            {
                return NotFound();
            }

            _context.TeacherCategories.Remove(teacherCategory);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool TeacherCategoryExists(int id)
        {
            return (_context.TeacherCategories?.Any(e => e.TeacherCategoryId == id)).GetValueOrDefault();
        }
    }
}
