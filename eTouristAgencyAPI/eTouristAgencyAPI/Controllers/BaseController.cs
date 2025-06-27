using eTouristAgencyAPI.Models.ResponseModels;
using eTouristAgencyAPI.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace eTouristAgencyAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public abstract class BaseController<TDbModel, TResponseModel, TSearchModel> : ControllerBase
    {
        protected readonly IBaseService<TDbModel, TResponseModel, TSearchModel> _service;

        public BaseController(IBaseService<TDbModel, TResponseModel, TSearchModel> baseService)
        {
            _service = baseService;
        }

        [HttpGet]
        public virtual async Task<ActionResult<PaginatedList<TResponseModel>>> GetAll([FromQuery] TSearchModel searchModel)
        {
            try
            {
                var paginatedListModel = await _service.GetAllAsync(searchModel);
                return Ok(paginatedListModel);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpGet("{id}")]
        public virtual async Task<ActionResult<TResponseModel>> GetById(Guid id)
        {
            try
            {
                var responseModel = await _service.GetByIdAsync(id);
                return Ok(responseModel);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }
    }
}
