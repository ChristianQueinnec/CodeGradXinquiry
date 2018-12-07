// CodeGradXinquiry
// Time-stamp: "2018-12-07 09:10:16 queinnec"

/** Complements to CodeGradXlib. These complements require to be an
    admin of the CodeGradX infrastructure.

@module codegradxlib
@author Christian Queinnec <Christian.Queinnec@codegradx.org>
@license MIT
@see {@link http://codegradx.org/|CodeGradX} site.
*/

import CodeGradX from 'codegradxlib';

/** Re-export the `CodeGradX` object */
//module.exports = CodeGradX;
export default CodeGradX;

/** Get information about someone. This method requires to be admin.

    @param {integer} id of a Person
      @property {string} fields.lastname
      @property {string} fields.firstname
      @property {string} fields.pseudo
      @property {string} fields.email
      @property {string} fields.password
      @returns {Promise} yields User
*/

CodeGradX.State.prototype.getPerson = function (personid) {
    const state = CodeGradX.getCurrentState();
    state.debug('getPerson1', personid);
    const person = new CodeGradX.User({personid});
    return state.sendAXServer('x', {
        path: `/inquiry/person/${personid}`,
        method: 'POST',
        headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/x-www-form-urlencoded'
        }
    }).then((response) => {
        state.debug('getPerson2', response.entity);
        return Promise.resolve(new CodeGradX.User(response.entity));
    });
};

/** Get information about an exercise. This method requires to be admin.
 */

CodeGradX.State.prototype.getExercise = function (uuid) {
    const state = CodeGradX.getCurrentState();
    state.debug('getExercise1', uuid);
    return state.sendAXServer('x', {
        path: `/inquiry/exercise/${uuid}`,
        method: 'POST',
        headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/x-www-form-urlencoded'
        }
    }).then((response) => {
        state.debug('getExercise2', response.entity);
        return Promise.resolve(new CodeGradX.Exercise(response.entity));
    });
};

/** Get information about a MarkEngine. This method requires to be admin.
 */

CodeGradX.State.prototype.getMarkEngines = function () {
    const state = CodeGradX.getCurrentState();
    state.debug('getMarkEngines1');
    return state.sendAXServer('x', {
        path: `/inquiry/markengines`,
        method: 'POST',
        headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/x-www-form-urlencoded'
        }
    }).then((response) => {
        state.debug('getMarkEngines2', response.entity);
        return Promise.resolve(response.entity);
    });
};

/** Get all notifications. This is restricted to authorized users only.

    @returns {Promise} yields Array[notification]
*/

CodeGradX.State.prototype.getAllNotifications = function (count, till) {
    let state = CodeGradX.getCurrentState();
    let user = this;
    state.debug('getAllNotifications1', count, till);
    function processResponse (response) {
        state.debug('getAllNotifications2', response);
        return response.entity;
    }
    let headers = {
        "Accept": 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded'
    };
    count = count ||
        CodeGradX.State.prototype.getAllNotifications.default.count;
    let entity = { count };
    if ( till ) {
        entity.till = till;
    }
    return state.sendAXServer('x', {
        path: ('/inquiry/notifications'),
        method: 'POST',
        headers: headers,
        entity: entity
    }).then(processResponse);
};
CodeGradX.State.prototype.getAllNotifications.default = {
    count: 10
};

// end of codegradxinquiry.js
