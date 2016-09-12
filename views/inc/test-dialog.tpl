<div aria-hidden="true" aria-labelledby="acceptModalLabel" role="dialog" tabindex="-1" id="acceptModal" class="modal fade">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <h4 class="modal-title">测试指派给?</h4>
          </div>
          <div class="modal-body">
            <select id="acceptid" class="form-control">
              <option value="">请选择指派给</option>
				{{range .teams}}
              <option value="{{.Userid}}">{{getRealname .Userid}}</option>
				{{end}}
            </select>
            <p></p>
            <textarea id="note" placeholder="备注说明" style="height:90px;" class="form-control"></textarea>
          </div>
          <div class="modal-footer">
            <input type="hidden" id="testid" />
            <button data-dismiss="modal" class="btn btn-default" type="button">取消</button>
            <button class="btn btn-primary js-dialog-testaccept" type="button">提交</button>
          </div>
        </div>
      </div>
    </div>
    <div aria-hidden="true" aria-labelledby="completeModalLabel" role="dialog" tabindex="-1" id="completeModal" class="modal fade">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <h4 class="modal-title">解决方案</h4>
          </div>
          <div class="modal-body">
            <select id="cstatus" class="form-control">
              <option value="">解决方案</option>
              <option value="1">设计如此</option>
              <option value="2">重复Bug</option>
              <option value="3">外部原因</option>
              <option value="4">已解决</option>
              <option value="5">无法重现</option>
              <option value="6">延期处理</option>
              <option value="7">不予解决</option>
            </select>
            <p></p>
            <textarea id="cnote" placeholder="备注说明" style="height:90px;" class="form-control"></textarea>
          </div>
          <div class="modal-footer">
            <input type="hidden" id="ctestid" />
            <button data-dismiss="modal" class="btn btn-default" type="button">取消</button>
            <button class="btn btn-primary js-dialog-testcomplete" type="button">提交</button>
          </div>
        </div>
      </div>
    </div>